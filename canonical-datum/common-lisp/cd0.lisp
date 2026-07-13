(in-package #:lisp-plus-cd0)

;;;; Lisp+ Canonical Datum /0 -- independent Common Lisp seed.
;;;;
;;;; This file implements the abstract datum algebra and canonical byte grammar
;;;; directly.  It deliberately does not use the Common Lisp reader/printer as
;;;; an identity mechanism and has no dependency on the existing v1 runtime.

;;; ---------------------------------------------------------------------------
;;; Failures

(define-condition cd0-failure (error)
  ((category :initarg :category :reader failure-category)
   (code :initarg :code :reader failure-code)
   (stage :initarg :stage :reader failure-stage)
   (offset :initarg :offset :initform nil :reader failure-offset)
   (path :initarg :path :initform nil :reader %failure-path)
   (detail :initarg :detail :initform nil :reader failure-detail)
   (budget-id :initarg :budget-id :initform nil :reader %failure-budget-id))
  (:report
   (lambda (condition stream)
     (format stream "CD/0 ~A/~A at ~A~@[ (octet ~D)~]"
             (failure-category condition)
             (failure-code condition)
             (failure-stage condition)
             (failure-offset condition)))))

(declaim (ftype function budget-id))

(defun failure-path (condition)
  (copy-tree (%failure-path condition)))

(defun failure-budget-id (condition)
  (let ((identifier (%failure-budget-id condition)))
    (and identifier (copy-seq identifier))))

(defun %fail (category code stage &key offset path detail budget)
  (error 'cd0-failure
         :category category
         :code code
         :stage stage
         :offset offset
         :path (copy-tree path)
         :detail detail
         :budget-id (and budget (budget-id budget))))

(defun %host-failure (code &optional (detail nil))
  (%fail "UnsupportedHostInput" code "host-import" :detail detail))

(defun %resource-failure (code stage budget &key offset detail)
  (%fail "ResourceRefusal" code stage
         :offset offset :detail detail :budget budget))

(defmacro %with-allocation-refusal ((budget) &body body)
  `(handler-case (progn ,@body)
     (storage-condition ()
       (%resource-failure "AllocationRefused" "allocation" ,budget))))

(defun %ensure-host-array-length (length budget &optional offset)
  (when (>= length array-dimension-limit)
    (%resource-failure "AllocationRefused" "allocation" budget
                       :offset offset :detail length)))

;;; ---------------------------------------------------------------------------
;;; Immutable explicit budgets

(defclass %resource-budget ()
  ((id :initarg :id :reader %budget-id)
   (max-input-octets :initarg :max-input-octets :reader budget-max-input-octets)
   (max-output-octets :initarg :max-output-octets :reader budget-max-output-octets)
   (max-varint-octets :initarg :max-varint-octets :reader budget-max-varint-octets)
   (max-integer-bits :initarg :max-integer-bits :reader budget-max-integer-bits)
   (max-depth :initarg :max-depth :reader budget-max-depth)
   (max-nodes :initarg :max-nodes :reader budget-max-nodes)
   (max-sequence-items :initarg :max-sequence-items :reader budget-max-sequence-items)
   (max-record-fields :initarg :max-record-fields :reader budget-max-record-fields)
   (max-identifier-segments :initarg :max-identifier-segments
                            :reader budget-max-identifier-segments)
   (max-segment-octets :initarg :max-segment-octets :reader budget-max-segment-octets)
   (max-single-string-octets :initarg :max-single-string-octets
                             :reader budget-max-single-string-octets)
   (max-single-bytes-octets :initarg :max-single-bytes-octets
                            :reader budget-max-single-bytes-octets)
   (max-aggregate-payload-octets :initarg :max-aggregate-payload-octets
                                 :reader budget-max-aggregate-payload-octets)
   (max-total-record-key-octets :initarg :max-total-record-key-octets
                                :reader budget-max-total-record-key-octets)))

(deftype resource-budget () '%resource-budget)

(defun resource-budget-p (object)
  (typep object '%resource-budget))

(defun %require-limit (value name)
  (unless (and (integerp value) (not (minusp value)))
    (%host-failure "UnsupportedHostType"
                   (list name "must be a nonnegative integer")))
  value)

(defun make-resource-budget
    (&key
       (id "cd0-conformance-default")
       (max-input-octets 1048576)
       (max-output-octets 1048576)
       (max-varint-octets 64)
       (max-integer-bits 4096)
       (max-depth 128)
       (max-nodes 100000)
       (max-sequence-items 10000)
       (max-record-fields 10000)
       (max-identifier-segments 1024)
       (max-segment-octets 65536)
       (max-single-string-octets 1048576)
       (max-single-bytes-octets 1048576)
       (max-aggregate-payload-octets 1048576)
       (max-total-record-key-octets 1048576))
  (unless (stringp id)
    (%host-failure "UnsupportedHostType" "budget id must be a string"))
  (let ((limits
          (list max-input-octets max-output-octets max-varint-octets
                max-integer-bits max-depth max-nodes max-sequence-items
                max-record-fields max-identifier-segments max-segment-octets
                max-single-string-octets max-single-bytes-octets
                max-aggregate-payload-octets max-total-record-key-octets))
        (names
          '(:max-input-octets :max-output-octets :max-varint-octets
            :max-integer-bits :max-depth :max-nodes :max-sequence-items
            :max-record-fields :max-identifier-segments :max-segment-octets
            :max-single-string-octets :max-single-bytes-octets
            :max-aggregate-payload-octets :max-total-record-key-octets)))
    (mapc #'%require-limit limits names))
  (make-instance
   '%resource-budget
   :id (copy-seq id)
   :max-input-octets max-input-octets
   :max-output-octets max-output-octets
   :max-varint-octets max-varint-octets
   :max-integer-bits max-integer-bits
   :max-depth max-depth
   :max-nodes max-nodes
   :max-sequence-items max-sequence-items
   :max-record-fields max-record-fields
   :max-identifier-segments max-identifier-segments
   :max-segment-octets max-segment-octets
   :max-single-string-octets max-single-string-octets
   :max-single-bytes-octets max-single-bytes-octets
   :max-aggregate-payload-octets max-aggregate-payload-octets
   :max-total-record-key-octets max-total-record-key-octets))

(defparameter *default-resource-budget* (make-resource-budget))

(defun default-resource-budget ()
  *default-resource-budget*)

(defun budget-id (budget)
  (unless (resource-budget-p budget)
    (%host-failure "UnsupportedHostType" "not a ResourceBudget"))
  (copy-seq (%budget-id budget)))

(defun %plist-value-or (plist key fallback)
  (let ((tail (member key plist :test #'eq)))
    (if tail (second tail) fallback)))

(defun copy-resource-budget (budget &rest overrides)
  (unless (resource-budget-p budget)
    (%host-failure "UnsupportedHostType" "not a ResourceBudget"))
  (let ((allowed
          '(:id :max-input-octets :max-output-octets :max-varint-octets
            :max-integer-bits :max-depth :max-nodes :max-sequence-items
            :max-record-fields :max-identifier-segments :max-segment-octets
            :max-single-string-octets :max-single-bytes-octets
            :max-aggregate-payload-octets :max-total-record-key-octets)))
    (when (oddp (length overrides))
      (%host-failure "UnsupportedHostType" "budget overrides must be a plist"))
    (loop for tail on overrides by #'cddr
          for key = (car tail)
          do (unless (member key allowed :test #'eq)
               (%host-failure "UnsupportedHostType"
                              (list "unknown budget override" key)))))
  (make-resource-budget
   :id (%plist-value-or overrides :id (%budget-id budget))
   :max-input-octets
   (%plist-value-or overrides :max-input-octets (budget-max-input-octets budget))
   :max-output-octets
   (%plist-value-or overrides :max-output-octets (budget-max-output-octets budget))
   :max-varint-octets
   (%plist-value-or overrides :max-varint-octets (budget-max-varint-octets budget))
   :max-integer-bits
   (%plist-value-or overrides :max-integer-bits (budget-max-integer-bits budget))
   :max-depth (%plist-value-or overrides :max-depth (budget-max-depth budget))
   :max-nodes (%plist-value-or overrides :max-nodes (budget-max-nodes budget))
   :max-sequence-items
   (%plist-value-or overrides :max-sequence-items (budget-max-sequence-items budget))
   :max-record-fields
   (%plist-value-or overrides :max-record-fields (budget-max-record-fields budget))
   :max-identifier-segments
   (%plist-value-or overrides :max-identifier-segments
                    (budget-max-identifier-segments budget))
   :max-segment-octets
   (%plist-value-or overrides :max-segment-octets (budget-max-segment-octets budget))
   :max-single-string-octets
   (%plist-value-or overrides :max-single-string-octets
                    (budget-max-single-string-octets budget))
   :max-single-bytes-octets
   (%plist-value-or overrides :max-single-bytes-octets
                    (budget-max-single-bytes-octets budget))
   :max-aggregate-payload-octets
   (%plist-value-or overrides :max-aggregate-payload-octets
                    (budget-max-aggregate-payload-octets budget))
   :max-total-record-key-octets
   (%plist-value-or overrides :max-total-record-key-octets
                    (budget-max-total-record-key-octets budget))))

;;; ---------------------------------------------------------------------------
;;; Read-only octet snapshots

(defclass %octet-string ()
  ((storage :initarg :storage :reader %octet-storage)))

(deftype octet-string () '%octet-string)

(defun octet-string-p (object)
  (typep object '%octet-string))

(defun %copy-octet-vector (source &optional (start 0) (end (length source)))
  (let* ((length (- end start))
         (copy (make-array length :element-type '(unsigned-byte 8))))
    (loop for source-index from start below end
          for target-index from 0
          do (setf (aref copy target-index) (aref source source-index)))
    copy))

(defun %make-octet-string (storage &key trusted)
  (make-instance '%octet-string
                 :storage (if trusted storage (%copy-octet-vector storage))))

(defun octets-length (octets)
  (unless (octet-string-p octets)
    (%host-failure "UnsupportedHostType" "not an immutable octet string"))
  (length (%octet-storage octets)))

(defun octets-ref (octets index)
  (unless (octet-string-p octets)
    (%host-failure "UnsupportedHostType" "not an immutable octet string"))
  (aref (%octet-storage octets) index))

(defun octets-copy (octets)
  (unless (octet-string-p octets)
    (%host-failure "UnsupportedHostType" "not an immutable octet string"))
  (%copy-octet-vector (%octet-storage octets)))

(defparameter +lower-hex-digits+ "0123456789abcdef")

(defun octets-to-hex (octets)
  (unless (octet-string-p octets)
    (%host-failure "UnsupportedHostType" "not an immutable octet string"))
  (let* ((storage (%octet-storage octets))
         (result (make-string (* 2 (length storage)))))
    (loop for octet across storage
          for position from 0 by 2
          do (setf (char result position)
                   (char +lower-hex-digits+ (ash octet -4))
                   (char result (1+ position))
                   (char +lower-hex-digits+ (logand octet #x0f))))
    result))

(defun %lower-hex-value (character)
  (cond
    ((char<= #\0 character #\9) (- (char-code character) (char-code #\0)))
    ((char<= #\a character #\f) (+ 10 (- (char-code character) (char-code #\a))))
    (t nil)))

(defun hex-to-octets (text)
  (unless (and (stringp text) (evenp (length text)))
    (%host-failure "UnsupportedHostType" "hex must be an even-length string"))
  (let ((result (make-array (/ (length text) 2)
                            :element-type '(unsigned-byte 8))))
    (loop for input from 0 below (length text) by 2
          for output from 0
          for high = (%lower-hex-value (char text input))
          for low = (%lower-hex-value (char text (1+ input)))
          do (unless (and high low)
               (%host-failure "UnsupportedHostType"
                              "hex must use lowercase 0-9a-f"))
             (setf (aref result output) (+ (ash high 4) low)))
    (%make-octet-string result :trusted t)))

;;; ---------------------------------------------------------------------------
;;; Private immutable datum representations

(defclass %datum () ())
(deftype datum () '%datum)

(defclass %unit-datum (%datum) ())
(defclass %boolean-datum (%datum)
  ((value :initarg :value :reader %boolean-value)))
(defclass %integer-datum (%datum)
  ((value :initarg :value :reader %integer-value)))
(defclass %rational-datum (%datum)
  ((numerator :initarg :numerator :reader %rational-numerator)
   (denominator :initarg :denominator :reader %rational-denominator)))
(defclass %string-datum (%datum)
  ((utf8 :initarg :utf8 :reader %string-utf8)
   (scalar-count :initarg :scalar-count :reader %string-scalar-count)))
(defclass %bytes-datum (%datum)
  ((octets :initarg :octets :reader %bytes-octets)))
(defclass %identifier-datum (%datum)
  ((namespace :initarg :namespace :reader %identifier-namespace)
   (path :initarg :path :reader %identifier-path)))
(defclass %sequence-datum (%datum)
  ((elements :initarg :elements :reader %sequence-elements)))
(defclass %record-entry ()
  ((key :initarg :key :reader %entry-key)
   (value :initarg :value :reader %entry-value)
   (key-bytes :initarg :key-bytes :initform nil :reader %entry-key-bytes)))
(defclass %record-datum (%datum)
  ((entries :initarg :entries :reader %record-entries)))

(defparameter +unit-datum+ (make-instance '%unit-datum))
(defparameter +false-datum+ (make-instance '%boolean-datum :value nil))
(defparameter +true-datum+ (make-instance '%boolean-datum :value t))

(defun datum-p (object) (typep object '%datum))
(defun unit-datum-p (object) (typep object '%unit-datum))
(defun boolean-datum-p (object) (typep object '%boolean-datum))
(defun integer-datum-p (object) (typep object '%integer-datum))
(defun rational-datum-p (object) (typep object '%rational-datum))
(defun string-datum-p (object) (typep object '%string-datum))
(defun bytes-datum-p (object) (typep object '%bytes-datum))
(defun identifier-datum-p (object) (typep object '%identifier-datum))
(defun sequence-datum-p (object) (typep object '%sequence-datum))
(defun record-datum-p (object) (typep object '%record-datum))
(defun record-entry-p (object) (typep object '%record-entry))

(defun datum-family (datum)
  (cond
    ((unit-datum-p datum) :unit)
    ((boolean-datum-p datum) :boolean)
    ((integer-datum-p datum) :integer)
    ((rational-datum-p datum) :rational)
    ((string-datum-p datum) :string)
    ((bytes-datum-p datum) :bytes)
    ((identifier-datum-p datum) :identifier)
    ((sequence-datum-p datum) :sequence)
    ((record-datum-p datum) :record)
    (t (%host-failure "UnsupportedHostType" "not a CD/0 datum"))))

;;; ---------------------------------------------------------------------------
;;; Scalar and collection helpers

(defun %freeze-adjustable-octets (array)
  (%copy-octet-vector array 0 (length array)))

(defun %push-utf8-code-point (code output)
  (cond
    ((<= code #x7f)
     (vector-push-extend code output))
    ((<= code #x7ff)
     (vector-push-extend (logior #xc0 (ash code -6)) output)
     (vector-push-extend (logior #x80 (logand code #x3f)) output))
    ((<= code #xffff)
     (vector-push-extend (logior #xe0 (ash code -12)) output)
     (vector-push-extend (logior #x80 (logand (ash code -6) #x3f)) output)
     (vector-push-extend (logior #x80 (logand code #x3f)) output))
    (t
     (vector-push-extend (logior #xf0 (ash code -18)) output)
     (vector-push-extend (logior #x80 (logand (ash code -12) #x3f)) output)
     (vector-push-extend (logior #x80 (logand (ash code -6) #x3f)) output)
     (vector-push-extend (logior #x80 (logand code #x3f)) output))))

(defun %host-string-utf8-metrics (string)
  (unless (stringp string)
    (%host-failure "UnsupportedHostType" "expected an explicit host string"))
  (let ((octets 0)
        (scalars 0))
    (loop for character across string
          for code = (char-code character)
          do (unless (and (<= 0 code #x10ffff)
                          (not (<= #xd800 code #xdfff)))
               (%host-failure "InvalidHostUnicode" code))
             (incf octets
                   (cond ((<= code #x7f) 1)
                         ((<= code #x7ff) 2)
                         ((<= code #xffff) 3)
                         (t 4)))
             (incf scalars))
    (values octets scalars)))

(defun %utf8-from-host-string (string)
  (unless (stringp string)
    (%host-failure "UnsupportedHostType" "expected an explicit host string"))
  (let ((output (make-array 16 :element-type '(unsigned-byte 8)
                            :adjustable t :fill-pointer 0))
        (scalars 0))
    (loop for character across string
          for code = (char-code character)
          do (unless (and (<= 0 code #x10ffff)
                          (not (<= #xd800 code #xdfff)))
               (%host-failure "InvalidHostUnicode" code))
             (%push-utf8-code-point code output)
             (incf scalars))
    (values (%freeze-adjustable-octets output) scalars)))

(defun %continuation-octet-p (octet)
  (<= #x80 octet #xbf))

(defun %validate-utf8 (storage start end &key (mode :decode) (base-offset start))
  "Validate shortest-form UTF-8 and return the scalar count."
  (labels ((invalid (relative &optional forbidden)
             (if (eq mode :decode)
                 (%fail "InvalidCanonicalGrammar"
                        (if forbidden "ForbiddenUnicodeScalar" "InvalidUTF8")
                        "utf8" :offset (+ base-offset relative))
                 (%host-failure "InvalidHostUnicode"
                                (list "invalid UTF-8" (+ base-offset relative)))))
           (need (index count)
             (when (> (+ index count) end)
               (invalid (- index start)))))
    (let ((index start)
          (count 0))
      (loop while (< index end)
            for first = (aref storage index)
            do
               (cond
                 ((<= first #x7f)
                  (incf index))
                 ((<= #xc2 first #xdf)
                  (need index 2)
                  (unless (%continuation-octet-p (aref storage (1+ index)))
                    (invalid (- index start)))
                  (incf index 2))
                 ((= first #xe0)
                  (need index 3)
                  (unless (and (<= #xa0 (aref storage (1+ index)) #xbf)
                               (%continuation-octet-p (aref storage (+ index 2))))
                    (invalid (- index start)))
                  (incf index 3))
                 ((<= #xe1 first #xec)
                  (need index 3)
                  (unless (and (%continuation-octet-p (aref storage (1+ index)))
                               (%continuation-octet-p (aref storage (+ index 2))))
                    (invalid (- index start)))
                  (incf index 3))
                 ((= first #xed)
                  (need index 3)
                  (let ((second (aref storage (1+ index)))
                        (third (aref storage (+ index 2))))
                    (cond
                      ((and (<= #xa0 second #xbf)
                            (%continuation-octet-p third))
                       (invalid (- index start) t))
                      ((and (<= #x80 second #x9f)
                            (%continuation-octet-p third))
                       (incf index 3))
                      (t (invalid (- index start))))))
                 ((<= #xee first #xef)
                  (need index 3)
                  (unless (and (%continuation-octet-p (aref storage (1+ index)))
                               (%continuation-octet-p (aref storage (+ index 2))))
                    (invalid (- index start)))
                  (incf index 3))
                 ((= first #xf0)
                  (need index 4)
                  (unless (and (<= #x90 (aref storage (1+ index)) #xbf)
                               (%continuation-octet-p (aref storage (+ index 2)))
                               (%continuation-octet-p (aref storage (+ index 3))))
                    (invalid (- index start)))
                  (incf index 4))
                 ((<= #xf1 first #xf3)
                  (need index 4)
                  (unless (and (%continuation-octet-p (aref storage (1+ index)))
                               (%continuation-octet-p (aref storage (+ index 2)))
                               (%continuation-octet-p (aref storage (+ index 3))))
                    (invalid (- index start)))
                  (incf index 4))
                 ((= first #xf4)
                  (need index 4)
                  (unless (and (<= #x80 (aref storage (1+ index)) #x8f)
                               (%continuation-octet-p (aref storage (+ index 2)))
                               (%continuation-octet-p (aref storage (+ index 3))))
                    (invalid (- index start)))
                  (incf index 4))
                 (t (invalid (- index start))))
               (incf count))
      count)))

(defun %decode-utf8-host-string (storage)
  (%validate-utf8 storage 0 (length storage) :mode :host :base-offset 0)
  (let ((output (make-array 16 :element-type 'character
                            :adjustable t :fill-pointer 0))
        (index 0))
    (loop while (< index (length storage))
          for first = (aref storage index)
          for code =
            (cond
              ((<= first #x7f)
               (prog1 first (incf index)))
              ((<= first #xdf)
               (prog1
                   (logior (ash (logand first #x1f) 6)
                           (logand (aref storage (1+ index)) #x3f))
                 (incf index 2)))
              ((<= first #xef)
               (prog1
                   (logior (ash (logand first #x0f) 12)
                           (ash (logand (aref storage (1+ index)) #x3f) 6)
                           (logand (aref storage (+ index 2)) #x3f))
                 (incf index 3)))
              (t
               (prog1
                   (logior (ash (logand first #x07) 18)
                           (ash (logand (aref storage (1+ index)) #x3f) 12)
                           (ash (logand (aref storage (+ index 2)) #x3f) 6)
                           (logand (aref storage (+ index 3)) #x3f))
                 (incf index 4))))
          for character = (code-char code)
          do (unless character
               (%resource-failure "AllocationRefused" "allocation"
                                  (default-resource-budget)
                                  :detail (list "host cannot materialize scalar" code)))
             (vector-push-extend character output))
    (coerce output 'string)))

(defun %proper-sequence-vector (source &key limit budget
                                       (resource-code "ExcessiveContainerCount")
                                       (stage "host-import"))
  (labels ((check-limit (length)
             (when (and limit (> length limit))
               (if budget
                   (%resource-failure resource-code stage budget :detail length)
                   (%host-failure "UnsupportedHostType"
                                  "host sequence exceeds adapter limit")))))
  (cond
    ((vectorp source)
     (check-limit (length source))
     (let ((copy (make-array (length source))))
       (loop for index below (length source)
             do (setf (aref copy index) (aref source index)))
       copy))
    ((listp source)
     (let ((seen (make-hash-table :test #'eq))
           (items (make-array 8 :adjustable t :fill-pointer 0))
           (cursor source))
       (loop while (consp cursor)
             do (when (gethash cursor seen)
                  (%host-failure "CyclicHostInput"))
                (setf (gethash cursor seen) t)
                (check-limit (1+ (length items)))
                (vector-push-extend (car cursor) items)
                (setf cursor (cdr cursor)))
       (unless (null cursor)
         (%host-failure "ImproperHostList"))
       (coerce items 'simple-vector)))
    (t (%host-failure "UnsupportedHostType" "expected a list or vector")))))

(defun %ensure-datum (object)
  (unless (datum-p object)
    (%host-failure "UnsupportedHostType" "expected an explicit CD/0 datum"))
  object)

(defun %integer-bit-count (integer)
  ;; Errata 0.1: mathematical absolute-value bit length; zero consumes zero.
  (integer-length (abs integer)))

(defun %check-integer-budget (integer budget stage &optional offset)
  (when (> (%integer-bit-count integer) (budget-max-integer-bits budget))
    (%resource-failure "IntegerBudgetExceeded" stage budget
                       :offset offset :detail (%integer-bit-count integer))))

(defun %check-payload-budget (length single-limit aggregate-so-far budget stage
                              &optional offset)
  (when (> length single-limit)
    (%resource-failure "ExcessiveDeclaredLength" stage budget
                       :offset offset :detail length))
  (when (> (+ aggregate-so-far length)
           (budget-max-aggregate-payload-octets budget))
    (%resource-failure "AggregatePayloadBudgetExceeded" stage budget
                       :offset offset :detail (+ aggregate-so-far length)))
  (+ aggregate-so-far length))

;;; ---------------------------------------------------------------------------
;;; Explicit constructors and defensive accessors

(defun make-unit-datum () +unit-datum+)

(defun make-boolean-datum (truth-value)
  ;; NIL is unambiguous here only because the explicitly named constructor fixes
  ;; the expected family.  No generic NIL importer exists.
  (cond ((eq truth-value t) +true-datum+)
        ((null truth-value) +false-datum+)
        (t (%host-failure "UnsupportedHostType"
                          "boolean constructor accepts only T or NIL"))))

(defun make-integer-datum (value &key (budget (default-resource-budget)))
  (unless (integerp value)
    (%host-failure "UnsupportedHostType" "integer constructor requires an integer"))
  (%check-integer-budget value budget "host-import")
  (make-instance '%integer-datum :value value))

(defun make-rational-datum (numerator denominator
                            &key (budget (default-resource-budget)))
  (unless (and (integerp numerator) (integerp denominator))
    (%host-failure "UnsupportedHostType"
                   "rational constructor requires two integers"))
  (when (zerop denominator)
    (%host-failure "ZeroDenominator"))
  ;; Errata 0.1 checks the supplied mathematical components before GCD work.
  ;; The post-normalization checks below retain the private runtime invariant.
  (%check-integer-budget numerator budget "host-import")
  (%check-integer-budget denominator budget "host-import")
  (when (minusp denominator)
    (setf numerator (- numerator)
          denominator (- denominator)))
  (let ((divisor (gcd (abs numerator) denominator)))
    (setf numerator (/ numerator divisor)
          denominator (/ denominator divisor)))
  (%check-integer-budget numerator budget "host-import")
  (%check-integer-budget denominator budget "host-import")
  (cond
    ((zerop numerator) (make-integer-datum 0 :budget budget))
    ((= denominator 1) (make-integer-datum numerator :budget budget))
    (t (make-instance '%rational-datum
                      :numerator numerator :denominator denominator))))

(defun make-string-datum (value &key (budget (default-resource-budget)))
  (multiple-value-bind (octet-count scalar-count)
      (%host-string-utf8-metrics value)
    (%check-payload-budget octet-count
                           (budget-max-single-string-octets budget)
                           0 budget "host-import")
    (multiple-value-bind (utf8 encoded-scalar-count)
        (%utf8-from-host-string value)
      (unless (= scalar-count encoded-scalar-count)
        (%fail "InternalInvariantFailure" "EncoderInvariantFailure" "internal"))
      (make-instance '%string-datum :utf8 utf8 :scalar-count scalar-count))))

(defun %snapshot-host-octets (source)
  (cond
    ((octet-string-p source)
     (%copy-octet-vector (%octet-storage source)))
    ((vectorp source)
     (let ((copy (make-array (length source) :element-type '(unsigned-byte 8))))
       (loop for index below (length source)
             for item = (aref source index)
             do (unless (typep item '(integer 0 255))
                  (%host-failure "UnsupportedHostType"
                                 "byte source contains a non-octet"))
                (setf (aref copy index) item))
       copy))
    ((listp source)
     (let ((items (%proper-sequence-vector source)))
       (%snapshot-host-octets items)))
    (t (%host-failure "UnsupportedHostType"
                      "byte constructor requires octets, a vector, or a proper list"))))

(defun make-bytes-datum (source &key (budget (default-resource-budget)))
  (let* ((prepared
           (if (listp source)
               (%proper-sequence-vector
                source :limit (budget-max-single-bytes-octets budget)
                :budget budget :resource-code "ExcessiveDeclaredLength")
               source))
         (length
           (cond ((octet-string-p prepared) (octets-length prepared))
                 ((vectorp prepared) (length prepared))
                 (t (%host-failure "UnsupportedHostType"
                                   "byte constructor requires octet storage")))))
    (%check-payload-budget length
                           (budget-max-single-bytes-octets budget)
                           0 budget "host-import")
    (make-instance '%bytes-datum :octets (%snapshot-host-octets prepared))))

(defun %segments-from-host (source budget
                            &key
                              (aggregate-so-far 0)
                              (segment-limit
                                (budget-max-identifier-segments budget)))
  (let* ((items
           (%proper-sequence-vector
            source :limit segment-limit
            :budget budget :resource-code "ExcessiveIdentifierSegments"))
         (result (make-array (length items)))
         (aggregate aggregate-so-far))
    (loop for index below (length items)
          for segment = (aref items index)
          do (multiple-value-bind (octet-count scalar-count)
                 (%host-string-utf8-metrics segment)
               (declare (ignore scalar-count))
               (when (zerop octet-count)
                 (%host-failure "EmptyIdentifierSegment"))
               (when (> octet-count (budget-max-segment-octets budget))
                 (%resource-failure "ExcessiveDeclaredLength" "host-import" budget
                                    :detail octet-count))
               (setf aggregate
                     (%check-payload-budget
                      octet-count (budget-max-segment-octets budget)
                      aggregate budget "host-import"))
               (multiple-value-bind (utf8 encoded-scalar-count)
                   (%utf8-from-host-string segment)
                 (declare (ignore encoded-scalar-count))
                 (setf (aref result index) utf8))))
    (values result aggregate)))

(defun make-identifier-datum (namespace path
                              &key (budget (default-resource-budget)))
  (multiple-value-bind (namespace-segments namespace-payload)
      (%segments-from-host namespace budget)
    (multiple-value-bind (path-segments path-payload)
        (%segments-from-host
         path budget
         :aggregate-so-far namespace-payload
         :segment-limit (- (budget-max-identifier-segments budget)
                           (length namespace-segments)))
      (when (zerop (length path-segments))
        (%host-failure "MissingIdentifierPath"))
      ;; Errata 0.1: the limit is aggregate across both sides.
      (when (> (+ (length namespace-segments) (length path-segments))
               (budget-max-identifier-segments budget))
        (%resource-failure "ExcessiveIdentifierSegments" "host-import" budget))
      (when (> path-payload (budget-max-aggregate-payload-octets budget))
        (%resource-failure "AggregatePayloadBudgetExceeded" "host-import" budget))
      (make-instance '%identifier-datum
                     :namespace namespace-segments :path path-segments))))

(defun make-sequence-datum (source &key (budget (default-resource-budget)))
  (let ((elements
          (%proper-sequence-vector
           source :limit (budget-max-sequence-items budget) :budget budget)))
    (loop for element across elements do (%ensure-datum element))
    (make-instance '%sequence-datum :elements elements)))

(defun make-record-entry (key value)
  (unless (identifier-datum-p key)
    (%host-failure "UnsupportedHostType" "record key must be an identifier datum"))
  (%ensure-datum value)
  (make-instance '%record-entry :key key :value value))

(defun record-entry-key (entry)
  (unless (record-entry-p entry)
    (%host-failure "UnsupportedHostType" "not a record entry"))
  (%entry-key entry))

(defun record-entry-value (entry)
  (unless (record-entry-p entry)
    (%host-failure "UnsupportedHostType" "not a record entry"))
  (%entry-value entry))

(defun boolean-datum-value (datum)
  (unless (boolean-datum-p datum) (%host-failure "UnsupportedHostType"))
  (%boolean-value datum))

(defun integer-datum-value (datum)
  (unless (integer-datum-p datum) (%host-failure "UnsupportedHostType"))
  (%integer-value datum))

(defun rational-datum-numerator (datum)
  (unless (rational-datum-p datum) (%host-failure "UnsupportedHostType"))
  (%rational-numerator datum))

(defun rational-datum-denominator (datum)
  (unless (rational-datum-p datum) (%host-failure "UnsupportedHostType"))
  (%rational-denominator datum))

(defun string-datum-value (datum)
  (unless (string-datum-p datum) (%host-failure "UnsupportedHostType"))
  (%decode-utf8-host-string (%string-utf8 datum)))

(defun string-datum-scalar-length (datum)
  (unless (string-datum-p datum) (%host-failure "UnsupportedHostType"))
  (%string-scalar-count datum))

(defun bytes-datum-value (datum)
  (unless (bytes-datum-p datum) (%host-failure "UnsupportedHostType"))
  (%copy-octet-vector (%bytes-octets datum)))

(defun %segments-to-host-vector (segments)
  (let ((result (make-array (length segments))))
    (loop for index below (length segments)
          do (setf (aref result index)
                   (%decode-utf8-host-string (aref segments index))))
    result))

(defun identifier-datum-namespace (datum)
  (unless (identifier-datum-p datum) (%host-failure "UnsupportedHostType"))
  (%segments-to-host-vector (%identifier-namespace datum)))

(defun identifier-datum-path (datum)
  (unless (identifier-datum-p datum) (%host-failure "UnsupportedHostType"))
  (%segments-to-host-vector (%identifier-path datum)))

(defun identifier-datum-namespace-count (datum)
  (unless (identifier-datum-p datum) (%host-failure "UnsupportedHostType"))
  (length (%identifier-namespace datum)))

(defun identifier-datum-path-count (datum)
  (unless (identifier-datum-p datum) (%host-failure "UnsupportedHostType"))
  (length (%identifier-path datum)))

(defun identifier-datum-namespace-segment (datum index)
  (unless (identifier-datum-p datum) (%host-failure "UnsupportedHostType"))
  (%decode-utf8-host-string (aref (%identifier-namespace datum) index)))

(defun identifier-datum-path-segment (datum index)
  (unless (identifier-datum-p datum) (%host-failure "UnsupportedHostType"))
  (%decode-utf8-host-string (aref (%identifier-path datum) index)))

(defun sequence-datum-length (datum)
  (unless (sequence-datum-p datum) (%host-failure "UnsupportedHostType"))
  (length (%sequence-elements datum)))

(defun sequence-datum-ref (datum index)
  (unless (sequence-datum-p datum) (%host-failure "UnsupportedHostType"))
  (aref (%sequence-elements datum) index))

(defun sequence-datum-elements (datum)
  (unless (sequence-datum-p datum) (%host-failure "UnsupportedHostType"))
  (copy-seq (%sequence-elements datum)))

;;; ---------------------------------------------------------------------------
;;; Canonical identifier key bytes and records

(defun %uvar-length (integer)
  (if (zerop integer)
      1
      (ceiling (integer-length integer) 7)))

(defun %uvar-vector (integer)
  (let ((result (make-array (%uvar-length integer)
                            :element-type '(unsigned-byte 8)))
        (remaining integer))
    (loop for index below (length result)
          for payload = (logand remaining #x7f)
          do (setf remaining (ash remaining -7)
                   (aref result index)
                   (if (zerop remaining) payload (logior payload #x80))))
    result))

(defun %identifier-value-length (identifier)
  (+ 1
     (%uvar-length (length (%identifier-namespace identifier)))
     (loop for segment across (%identifier-namespace identifier)
           sum (+ (%uvar-length (length segment)) (length segment)))
     (%uvar-length (length (%identifier-path identifier)))
     (loop for segment across (%identifier-path identifier)
           sum (+ (%uvar-length (length segment)) (length segment)))))

(defun %copy-into (source target position)
  (loop for octet across source
        do (setf (aref target position) octet)
           (incf position))
  position)

(defun %identifier-value-bytes (identifier)
  (let ((result (make-array (%identifier-value-length identifier)
                            :element-type '(unsigned-byte 8)))
        (position 0))
    (setf (aref result position) #x22)
    (incf position)
    (setf position (%copy-into (%uvar-vector (length (%identifier-namespace identifier)))
                               result position))
    (loop for segment across (%identifier-namespace identifier)
          do (setf position (%copy-into (%uvar-vector (length segment)) result position)
                   position (%copy-into segment result position)))
    (setf position (%copy-into (%uvar-vector (length (%identifier-path identifier)))
                               result position))
    (loop for segment across (%identifier-path identifier)
          do (setf position (%copy-into (%uvar-vector (length segment)) result position)
                   position (%copy-into segment result position)))
    (unless (= position (length result))
      (%fail "InternalInvariantFailure" "EncoderInvariantFailure" "internal"))
    result))

(defun %octets-compare (left right)
  "Return -1, 0, or 1 under unsigned lexicographic ordering."
  (loop for index below (min (length left) (length right))
        for a = (aref left index)
        for b = (aref right index)
        when (< a b) do (return-from %octets-compare -1)
        when (> a b) do (return-from %octets-compare 1))
  (cond ((< (length left) (length right)) -1)
        ((> (length left) (length right)) 1)
        (t 0)))

(defun %normalize-record-entries (source budget stage)
  (let ((entries
          (%proper-sequence-vector
           source :limit (budget-max-record-fields budget)
           :budget budget :stage stage)))
    (let ((normalized (make-array (length entries)))
          (key-work 0))
      ;; Errata 0.1: complete Identifier ValueBytes counted once per key.
      (loop for index below (length entries)
            for entry = (aref entries index)
            do (unless (record-entry-p entry)
                 (%host-failure "UnsupportedHostType"
                                "record fields must be explicit record entries"))
               (unless (identifier-datum-p (%entry-key entry))
                 (%host-failure "UnsupportedHostType"
                                "record entry key is not an identifier"))
               (%ensure-datum (%entry-value entry))
               (let ((key-length
                       (%identifier-value-length (%entry-key entry))))
                 ;; The length is derivable from already immutable segment
                 ;; snapshots.  Enforce the work budget before allocating the
                 ;; proportional complete Identifier ValueBytes buffer.
                 (incf key-work key-length)
                 (when (> key-work (budget-max-total-record-key-octets budget))
                   (%resource-failure "RecordKeyWorkBudgetExceeded" stage budget
                                      :detail key-work))
                 (let ((key-bytes
                         (%identifier-value-bytes (%entry-key entry))))
                   (setf (aref normalized index)
                         (make-instance '%record-entry
                                        :key (%entry-key entry)
                                        :value (%entry-value entry)
                                        :key-bytes key-bytes)))))
      ;; Stability is semantically irrelevant because duplicates are rejected
      ;; immediately afterward, but STABLE-SORT is portable and explicit here.
      (setf normalized
            (stable-sort normalized
                         (lambda (left right)
                           (= -1 (%octets-compare (%entry-key-bytes left)
                                                  (%entry-key-bytes right))))))
      (loop for index from 1 below (length normalized)
            for previous = (aref normalized (1- index))
            for current = (aref normalized index)
            when (zerop (%octets-compare (%entry-key-bytes previous)
                                         (%entry-key-bytes current)))
              do (%host-failure "DuplicateRecordField"))
      normalized)))

(defun make-record-datum (entries &key (budget (default-resource-budget)))
  (make-instance '%record-datum
                 :entries (%normalize-record-entries entries budget "host-import")))

(defun record-datum-size (datum)
  (unless (record-datum-p datum) (%host-failure "UnsupportedHostType"))
  (length (%record-entries datum)))

(defun record-datum-key-at (datum index)
  (unless (record-datum-p datum) (%host-failure "UnsupportedHostType"))
  (%entry-key (aref (%record-entries datum) index)))

(defun record-datum-value-at (datum index)
  (unless (record-datum-p datum) (%host-failure "UnsupportedHostType"))
  (%entry-value (aref (%record-entries datum) index)))

(defun record-datum-fields (datum)
  (unless (record-datum-p datum) (%host-failure "UnsupportedHostType"))
  (let* ((entries (%record-entries datum))
         (result (make-array (length entries))))
    (loop for index below (length entries)
          for entry = (aref entries index)
          do (setf (aref result index)
                   (make-instance '%record-entry
                                  :key (%entry-key entry)
                                  :value (%entry-value entry))))
    result))

(defun record-datum-ref (datum key)
  (unless (and (record-datum-p datum) (identifier-datum-p key))
    (%host-failure "UnsupportedHostType"))
  (let ((target (%identifier-value-bytes key))
        (entries (%record-entries datum)))
    (loop with low = 0
          with high = (length entries)
          while (< low high)
          for middle = (floor (+ low high) 2)
          for entry = (aref entries middle)
          for comparison = (%octets-compare (%entry-key-bytes entry) target)
          do (cond ((minusp comparison) (setf low (1+ middle)))
                   ((plusp comparison) (setf high middle))
                   (t (return-from record-datum-ref
                        (values (%entry-value entry) t))))
          finally (return (values nil nil)))))

;;; ---------------------------------------------------------------------------
;;; Structural datum equality

(defun %octets-equal (left right)
  (and (= (length left) (length right))
       (loop for index below (length left)
             always (= (aref left index) (aref right index)))))

(defun %segments-equal (left right)
  (and (= (length left) (length right))
       (loop for index below (length left)
             always (%octets-equal (aref left index) (aref right index)))))

(defun equal-datum (left right)
  (unless (and (datum-p left) (datum-p right))
    (%host-failure "UnsupportedHostType" "equal-datum requires two datums"))
  ;; Equality is mathematically recursive, but a host call stack is not part of
  ;; that algebra.  Keep pending datum pairs on an explicit worklist so deeply
  ;; nested, independently constructed values remain ordinary finite inputs.
  (let ((worklist (list (cons left right))))
    (loop while worklist
          for pair = (pop worklist)
          for current-left = (car pair)
          for current-right = (cdr pair)
          do
             (cond
               ;; Runtime datums are immutable, so shared identity is a sound
               ;; fast path without making sharing observable.
               ((eq current-left current-right))
               ((unit-datum-p current-left)
                (unless (unit-datum-p current-right)
                  (return-from equal-datum nil)))
               ((boolean-datum-p current-left)
                (unless (and (boolean-datum-p current-right)
                             (eq (%boolean-value current-left)
                                 (%boolean-value current-right)))
                  (return-from equal-datum nil)))
               ((integer-datum-p current-left)
                (unless (and (integer-datum-p current-right)
                             (= (%integer-value current-left)
                                (%integer-value current-right)))
                  (return-from equal-datum nil)))
               ((rational-datum-p current-left)
                (unless (and (rational-datum-p current-right)
                             (= (%rational-numerator current-left)
                                (%rational-numerator current-right))
                             (= (%rational-denominator current-left)
                                (%rational-denominator current-right)))
                  (return-from equal-datum nil)))
               ((string-datum-p current-left)
                (unless (and (string-datum-p current-right)
                             (%octets-equal (%string-utf8 current-left)
                                            (%string-utf8 current-right)))
                  (return-from equal-datum nil)))
               ((bytes-datum-p current-left)
                (unless (and (bytes-datum-p current-right)
                             (%octets-equal (%bytes-octets current-left)
                                            (%bytes-octets current-right)))
                  (return-from equal-datum nil)))
               ((identifier-datum-p current-left)
                (unless
                    (and (identifier-datum-p current-right)
                         (%segments-equal (%identifier-namespace current-left)
                                          (%identifier-namespace current-right))
                         (%segments-equal (%identifier-path current-left)
                                          (%identifier-path current-right)))
                  (return-from equal-datum nil)))
               ((sequence-datum-p current-left)
                (unless (sequence-datum-p current-right)
                  (return-from equal-datum nil))
                (let ((left-elements (%sequence-elements current-left))
                      (right-elements (%sequence-elements current-right)))
                  (unless (= (length left-elements) (length right-elements))
                    (return-from equal-datum nil))
                  (loop for index below (length left-elements)
                        do (push (cons (aref left-elements index)
                                       (aref right-elements index))
                                 worklist))))
               ((record-datum-p current-left)
                (unless (record-datum-p current-right)
                  (return-from equal-datum nil))
                (let ((left-entries (%record-entries current-left))
                      (right-entries (%record-entries current-right)))
                  (unless (= (length left-entries) (length right-entries))
                    (return-from equal-datum nil))
                  (loop for index below (length left-entries)
                        for left-entry = (aref left-entries index)
                        for right-entry = (aref right-entries index)
                        do (push (cons (%entry-key left-entry)
                                       (%entry-key right-entry))
                                 worklist)
                           (push (cons (%entry-value left-entry)
                                       (%entry-value right-entry))
                                 worklist))))
               (t
                ;; A non-datum cannot occur below a successfully constructed
                ;; public datum; treat a violated private invariant as unequal.
                (return-from equal-datum nil))))
    t))

;;; ---------------------------------------------------------------------------
;;; Canonical encoder

(defstruct (%encoder-state
             (:constructor %new-encoder-state (budget output)))
  budget
  output
  (record-key-work 0 :type integer))

(defun %emit-octet (state octet)
  (when (>= (length (%encoder-state-output state))
            (budget-max-output-octets (%encoder-state-budget state)))
    ;; Errata 0.1: atomic output refusal uses the allocation stage.
    (%resource-failure "ExcessiveOutputLength" "allocation"
                       (%encoder-state-budget state)
                       :detail (1+ (length (%encoder-state-output state)))))
  (%ensure-host-array-length (1+ (length (%encoder-state-output state)))
                             (%encoder-state-budget state))
  (vector-push-extend octet (%encoder-state-output state)))

(defun %emit-octets (state octets)
  (when (> (+ (length (%encoder-state-output state)) (length octets))
           (budget-max-output-octets (%encoder-state-budget state)))
    (%resource-failure "ExcessiveOutputLength" "allocation"
                       (%encoder-state-budget state)
                       :detail (+ (length (%encoder-state-output state))
                                  (length octets))))
  (%ensure-host-array-length (+ (length (%encoder-state-output state))
                                (length octets))
                             (%encoder-state-budget state))
  (loop for octet across octets do
    (vector-push-extend octet (%encoder-state-output state))))

(defun %emit-uvar (state integer)
  ;; Runtime encoding receives an already-valid datum.  Errata 0.1 assigns
  ;; varint work only to decode, so this shared budget field is ignored here.
  (%emit-octets state (%uvar-vector integer)))

(defun %zigzag (integer)
  (if (minusp integer) (1- (* -2 integer)) (* 2 integer)))

(defun %encode-segments (state segments)
  (%emit-uvar state (length segments))
  (loop for segment across segments
        do (%emit-uvar state (length segment))
           (%emit-octets state segment)))

(defun %encode-identifier-after-tag (state identifier)
  (let* ((namespace (%identifier-namespace identifier))
         (path (%identifier-path identifier)))
    (when (zerop (length path))
      (%fail "InternalInvariantFailure" "EncoderInvariantFailure" "internal"))
    (%encode-segments state namespace)
    (%encode-segments state path)))

(defun %encode-value (state datum)
  (%ensure-datum datum)
  (cond
    ((unit-datum-p datum)
     (%emit-octet state #x00))
    ((boolean-datum-p datum)
     (%emit-octet state (if (%boolean-value datum) #x02 #x01)))
    ((integer-datum-p datum)
     (%emit-octet state #x10)
     (%emit-uvar state (%zigzag (%integer-value datum))))
    ((rational-datum-p datum)
     (let ((numerator (%rational-numerator datum))
           (denominator (%rational-denominator datum)))
       (unless (and (not (zerop numerator)) (> denominator 1)
                    (= 1 (gcd (abs numerator) denominator)))
         (%fail "InternalInvariantFailure" "EncoderInvariantFailure" "internal"))
       (%emit-octet state #x11)
       (%emit-uvar state (%zigzag numerator))
       (%emit-uvar state denominator)))
    ((string-datum-p datum)
     (let ((payload (%string-utf8 datum)))
       (%emit-octet state #x20)
       (%emit-uvar state (length payload))
       (%emit-octets state payload)))
    ((bytes-datum-p datum)
     (let ((payload (%bytes-octets datum)))
       (%emit-octet state #x21)
       (%emit-uvar state (length payload))
       (%emit-octets state payload)))
    ((identifier-datum-p datum)
     (%emit-octet state #x22)
     (%encode-identifier-after-tag state datum))
    ((sequence-datum-p datum)
     (let ((elements (%sequence-elements datum)))
       (%emit-octet state #x30)
       (%emit-uvar state (length elements))
       (loop for element across elements
             do (%encode-value state element))))
    ((record-datum-p datum)
     (let* ((entries (%record-entries datum))
            (budget (%encoder-state-budget state))
            (previous nil))
       (%emit-octet state #x31)
       (%emit-uvar state (length entries))
       (loop for entry across entries
             for fresh-key-bytes = (%identifier-value-bytes (%entry-key entry))
             do (unless (and (%entry-key-bytes entry)
                             (%octets-equal fresh-key-bytes
                                            (%entry-key-bytes entry)))
                  (%fail "InternalInvariantFailure" "EncoderInvariantFailure"
                         "cache-check"))
                (when previous
                  (unless (= -1 (%octets-compare previous fresh-key-bytes))
                    (%fail "InternalInvariantFailure" "EncoderInvariantFailure"
                           "encode-ordering")))
                (setf previous fresh-key-bytes)
                (incf (%encoder-state-record-key-work state)
                      (length fresh-key-bytes))
                (when (> (%encoder-state-record-key-work state)
                         (budget-max-total-record-key-octets budget))
                  (%resource-failure "RecordKeyWorkBudgetExceeded"
                                     "encode-ordering" budget))
                (%encode-value state (%entry-key entry))
                (%encode-value state (%entry-value entry)))))
    (t (%fail "InternalInvariantFailure" "EncoderInvariantFailure" "internal"))))

(defun encode-exact (datum &key (budget (default-resource-budget)))
  (unless (resource-budget-p budget)
    (%host-failure "UnsupportedHostType" "encode budget is not a ResourceBudget"))
  (%ensure-datum datum)
  (%with-allocation-refusal (budget)
    (let* ((output (make-array 64 :element-type '(unsigned-byte 8)
                               :adjustable t :fill-pointer 0))
           (state (%new-encoder-state budget output)))
      ;; Errata 0.1 assigns runtime encode only output size, operation-wide
      ;; record-key work, and actual host allocation limits.
      (%emit-octets state #(76 80 67 68))
      (%emit-uvar state 0)
      (%encode-value state datum)
      (%make-octet-string (%freeze-adjustable-octets output) :trusted t))))

(defun canonical-octets (datum &key (budget (default-resource-budget)))
  (encode-exact datum :budget budget))

;;; ---------------------------------------------------------------------------
;;; Canonical-only exact decoder

(defstruct (%decoder-state
             (:constructor %new-decoder-state (storage budget)))
  storage
  budget
  (position 0 :type integer)
  (nodes 0 :type integer)
  (aggregate-payload 0 :type integer))

(defun %decoder-length (state)
  (length (%decoder-state-storage state)))

(defun %decoder-at-end-p (state)
  (>= (%decoder-state-position state) (%decoder-length state)))

(defun %decoder-peek (state)
  (and (not (%decoder-at-end-p state))
       (aref (%decoder-state-storage state) (%decoder-state-position state))))

(defun %decoder-read-octet (state stage)
  (when (%decoder-at-end-p state)
    (%fail "InvalidCanonicalGrammar" "TruncatedInput" stage
           :offset (%decoder-state-position state)))
  (prog1 (aref (%decoder-state-storage state) (%decoder-state-position state))
    (incf (%decoder-state-position state))))

(defun %decoder-enter-value (state depth)
  (let ((budget (%decoder-state-budget state)))
    ;; Errata 0.1: depth precedes node count on a simultaneous breach.
    (when (> depth (budget-max-depth budget))
      (%resource-failure "ExcessiveNesting" "type-tag" budget
                         :offset (%decoder-state-position state) :detail depth))
    (when (>= (%decoder-state-nodes state) (budget-max-nodes budget))
      (%resource-failure "NodeBudgetExceeded" "type-tag" budget
                         :offset (%decoder-state-position state)
                         :detail (1+ (%decoder-state-nodes state))))
    (incf (%decoder-state-nodes state))))

(defun %read-uvar (state stage nonminimal-code)
  (let ((value 0)
        (shift 0)
        (count 0)
        (last-payload 0)
        (budget (%decoder-state-budget state)))
    (loop
      ;; A continuing UVAR already at the limit is a resource refusal even if
      ;; the finite snapshot also ends here.
      (when (>= count (budget-max-varint-octets budget))
        (%resource-failure "VarintBudgetExceeded" stage budget
                           :offset (%decoder-state-position state)
                           :detail (1+ count)))
      (let* ((octet (%decoder-read-octet state stage))
             (payload (logand octet #x7f)))
        (setf last-payload payload
              value (logior value (ash payload shift)))
        (incf count)
        (if (zerop (logand octet #x80))
            (return)
            (incf shift 7))))
    (when (and (> count 1) (zerop last-payload))
      (%fail "NoncanonicalEncoding" nonminimal-code stage
             :offset (- (%decoder-state-position state) count)))
    value))

(defun %unzigzag (unsigned)
  (if (evenp unsigned)
      (/ unsigned 2)
      (- (/ (1+ unsigned) 2))))

(defun %decoder-check-integer (state integer stage offset)
  (%check-integer-budget integer (%decoder-state-budget state) stage offset))

(defun %decoder-add-payload (state length single-limit stage offset)
  (let ((budget (%decoder-state-budget state)))
    ;; Errata 0.1: single-payload limit precedes aggregate payload.
    (when (> length single-limit)
      (%resource-failure "ExcessiveDeclaredLength" stage budget
                         :offset offset :detail length))
    (when (> (+ (%decoder-state-aggregate-payload state) length)
             (budget-max-aggregate-payload-octets budget))
      (%resource-failure "AggregatePayloadBudgetExceeded" stage budget
                         :offset offset
                         :detail (+ (%decoder-state-aggregate-payload state)
                                    length)))
    (incf (%decoder-state-aggregate-payload state) length)))

(defun %decoder-take-payload (state length stage)
  (let ((start (%decoder-state-position state)))
    (when (> length (- (%decoder-length state) start))
      ;; Errata 0.1: declared-payload truncation remains at length stage.
      (%fail "InvalidCanonicalGrammar" "TruncatedInput" stage :offset start))
    (incf (%decoder-state-position state) length)
    (values (%copy-octet-vector (%decoder-state-storage state)
                                start (+ start length))
            start)))

(defun %read-length (state)
  (%read-uvar state "length" "OverlongLengthEncoding"))

(defun %read-count (state)
  (%read-uvar state "count" "OverlongCountEncoding"))

(defun %parse-string-after-tag (state)
  (let* ((length-offset (%decoder-state-position state))
         (length (%read-length state))
         (budget (%decoder-state-budget state)))
    (%decoder-add-payload state length
                          (budget-max-single-string-octets budget)
                          "length" length-offset)
    (multiple-value-bind (payload payload-offset)
        (%decoder-take-payload state length "length")
      (let ((scalar-count
              (%validate-utf8 payload 0 (length payload)
                              :mode :decode :base-offset payload-offset)))
        (make-instance '%string-datum
                       :utf8 payload :scalar-count scalar-count)))))

(defun %parse-bytes-after-tag (state)
  (let* ((length-offset (%decoder-state-position state))
         (length (%read-length state))
         (budget (%decoder-state-budget state)))
    (%decoder-add-payload state length
                          (budget-max-single-bytes-octets budget)
                          "length" length-offset)
    (multiple-value-bind (payload payload-offset)
        (%decoder-take-payload state length "length")
      (declare (ignore payload-offset))
      (make-instance '%bytes-datum :octets payload))))

(defun %parse-segment (state)
  (let* ((length-offset (%decoder-state-position state))
         (length (%read-length state))
         (budget (%decoder-state-budget state)))
    (when (zerop length)
      (%fail "InvalidCanonicalGrammar" "EmptyIdentifierSegment" "identifier"
             :offset length-offset))
    (%decoder-add-payload state length
                          (budget-max-segment-octets budget)
                          "length" length-offset)
    (multiple-value-bind (payload payload-offset)
        (%decoder-take-payload state length "length")
      (%validate-utf8 payload 0 (length payload)
                      :mode :decode :base-offset payload-offset)
      payload)))

(defun %parse-segment-vector (state count)
  (%ensure-host-array-length count (%decoder-state-budget state)
                             (%decoder-state-position state))
  (let ((segments (make-array count)))
    (loop for index below count
          do (when (%decoder-at-end-p state)
               ;; The count promised another segment, but its length UVAR has
               ;; not begun.  Once an octet exists, %PARSE-SEGMENT assigns the
               ;; length/UTF-8 stages normally.
               (%fail "InvalidCanonicalGrammar" "TruncatedInput" "count"
                      :offset (%decoder-state-position state)))
             (setf (aref segments index) (%parse-segment state)))
    segments))

(defun %parse-identifier-after-tag (state)
  (let* ((budget (%decoder-state-budget state))
         (namespace-count-offset (%decoder-state-position state))
         (namespace-count (%read-count state)))
    (when (> namespace-count (budget-max-identifier-segments budget))
      (%resource-failure "ExcessiveIdentifierSegments" "count" budget
                         :offset namespace-count-offset
                         :detail namespace-count))
    (let* ((namespace (%parse-segment-vector state namespace-count))
           (path-count-offset (%decoder-state-position state))
           (path-count (%read-count state)))
      (when (zerop path-count)
        (%fail "InvalidCanonicalGrammar" "MissingIdentifierPath" "identifier"
               :offset path-count-offset))
      ;; Errata 0.1: aggregate namespace + path segment budget.
      (when (> (+ namespace-count path-count)
               (budget-max-identifier-segments budget))
        (%resource-failure "ExcessiveIdentifierSegments" "count" budget
                           :offset path-count-offset
                           :detail (+ namespace-count path-count)))
      (let ((path (%parse-segment-vector state path-count)))
        (make-instance '%identifier-datum :namespace namespace :path path)))))

(defun %reserved-tag-p (tag)
  (or (<= #x03 tag #x0f)
      (<= #x12 tag #x1f)
      (<= #x23 tag #x2f)
      (<= #x32 tag #xef)))

(defun %parse-record-key (state depth)
  (%decoder-enter-value state depth)
  (when (%decoder-at-end-p state)
    (%fail "InvalidCanonicalGrammar" "TruncatedInput" "count"
           :offset (%decoder-state-position state)))
  (let ((tag (%decoder-peek state)))
    ;; Errata 0.1: forbidden privileged range retains its dedicated
    ;; security failure; every other non-22 byte is RecordKeyNotIdentifier.
    (when (<= #xf0 tag #xff)
      (%fail "PrivilegedRestorationAttempt" "ForbiddenPrivilegedTag" "type-tag"
             :offset (%decoder-state-position state)))
    (unless (= tag #x22)
      (%fail "InvalidCanonicalGrammar" "RecordKeyNotIdentifier" "record-key"
             :offset (%decoder-state-position state)))
    (incf (%decoder-state-position state))
    (%parse-identifier-after-tag state)))

(declaim (ftype function %parse-value))

(defun %parse-sequence-after-tag (state depth)
  (let* ((count-offset (%decoder-state-position state))
         (count (%read-count state))
         (budget (%decoder-state-budget state)))
    (when (> count (budget-max-sequence-items budget))
      (%resource-failure "ExcessiveContainerCount" "count" budget
                         :offset count-offset :detail count))
    (%ensure-host-array-length count budget count-offset)
    (let ((elements (make-array count)))
      (loop for index below count
            do (setf (aref elements index)
                     (%parse-value state (1+ depth) "count")))
      (make-instance '%sequence-datum :elements elements))))

(defun %parse-record-after-tag (state depth)
  (let* ((count-offset (%decoder-state-position state))
         (count (%read-count state))
         (budget (%decoder-state-budget state)))
    (when (> count (budget-max-record-fields budget))
      (%resource-failure "ExcessiveContainerCount" "count" budget
                         :offset count-offset :detail count))
    (%ensure-host-array-length count budget count-offset)
    (let ((entries (make-array count))
          (previous-key-bytes nil))
      (loop for index below count
            for key-start = (%decoder-state-position state)
            for key = (%parse-record-key state (1+ depth))
            for key-end = (%decoder-state-position state)
            for key-bytes = (%copy-octet-vector
                             (%decoder-state-storage state) key-start key-end)
            do
               (when previous-key-bytes
                 (let ((comparison (%octets-compare previous-key-bytes key-bytes)))
                   (cond
                     ((zerop comparison)
                      (%fail "InvalidCanonicalGrammar" "DuplicateRecordField"
                             "record-order" :offset key-start))
                     ((plusp comparison)
                      (%fail "NoncanonicalEncoding" "NoncanonicalFieldOrder"
                             "record-order" :offset key-start)))))
               ;; Ordering is checked before the associated value is parsed.
               (setf previous-key-bytes key-bytes)
               (let ((value (%parse-value state (1+ depth) "count")))
                 (setf (aref entries index)
                       (make-instance '%record-entry
                                      :key key :value value
                                      :key-bytes key-bytes))))
      (make-instance '%record-datum :entries entries))))

(defun %parse-value (state depth &optional (absent-stage "type-tag"))
  (%decoder-enter-value state depth)
  (when (%decoder-at-end-p state)
    ;; A surrounding count promises a complete nested item.  The count stage
    ;; applies only before that item's first octet; a present tag transfers
    ;; control to the nested value's own stage matrix.
    (%fail "InvalidCanonicalGrammar" "TruncatedInput" absent-stage
           :offset (%decoder-state-position state)))
  (let* ((tag-offset (%decoder-state-position state))
         (tag (%decoder-read-octet state "type-tag")))
    (cond
      ((<= #xf0 tag #xff)
       (%fail "PrivilegedRestorationAttempt" "ForbiddenPrivilegedTag" "type-tag"
              :offset tag-offset))
      ((%reserved-tag-p tag)
       (%fail "InvalidCanonicalGrammar" "ReservedTypeTag" "type-tag"
              :offset tag-offset))
      ((= tag #x00) +unit-datum+)
      ((= tag #x01) +false-datum+)
      ((= tag #x02) +true-datum+)
      ((= tag #x10)
       (let* ((payload-offset (%decoder-state-position state))
              (unsigned (%read-uvar state "integer-payload"
                                    "NonminimalIntegerEncoding"))
              (integer (%unzigzag unsigned)))
         (%decoder-check-integer state integer "integer-payload" payload-offset)
         (make-instance '%integer-datum :value integer)))
      ((= tag #x11)
       (let* ((payload-offset (%decoder-state-position state))
              (unsigned-numerator
                (%read-uvar state "rational-payload"
                            "NonminimalRationalComponentEncoding"))
              (numerator (%unzigzag unsigned-numerator)))
         ;; Section 20.5(6) applies the magnitude budget after each complete,
         ;; minimal UVAR.  In particular, a numerator refusal is determinable
         ;; before reading even the first denominator octet.
         (%decoder-check-integer state numerator "rational-payload" payload-offset)
         (let* ((denominator-offset (%decoder-state-position state))
                (denominator
                  (%read-uvar state "rational-payload"
                              "NonminimalRationalComponentEncoding")))
           (%decoder-check-integer state denominator "rational-payload"
                                   denominator-offset)
           (cond
             ((zerop denominator)
              (%fail "InvalidCanonicalGrammar" "ZeroDenominator"
                     "rational-payload" :offset denominator-offset))
             ((zerop numerator)
              (%fail "NoncanonicalEncoding" "ZeroRationalEncoding"
                     "rational-payload" :offset payload-offset))
             ((= denominator 1)
              (%fail "NoncanonicalEncoding" "IntegralRationalEncoding"
                     "rational-payload" :offset denominator-offset))
             ((/= 1 (gcd (abs numerator) denominator))
              (%fail "NoncanonicalEncoding" "UnreducedRational"
                     "rational-payload" :offset payload-offset))
             (t (make-instance '%rational-datum
                               :numerator numerator
                               :denominator denominator))))))
      ((= tag #x20) (%parse-string-after-tag state))
      ((= tag #x21) (%parse-bytes-after-tag state))
      ((= tag #x22) (%parse-identifier-after-tag state))
      ((= tag #x30) (%parse-sequence-after-tag state depth))
      ((= tag #x31) (%parse-record-after-tag state depth))
      (t
       ;; All octets are exhaustively assigned, so reaching this branch would
       ;; indicate a defect in the dispatch itself.
       (%fail "InternalInvariantFailure" "DecoderInvariantFailure" "internal"
              :offset tag-offset)))))

(defun %decode-input-snapshot (input budget)
  (let ((length
          (cond ((octet-string-p input) (length (%octet-storage input)))
                ((vectorp input) (length input))
                (t (%host-failure "UnsupportedHostType"
                                  "decode-exact requires octet storage")))))
    (when (> length (budget-max-input-octets budget))
      (%resource-failure "ExcessiveInputLength" "input-budget" budget
                         :detail length))
    (cond
      ((octet-string-p input)
       ;; The wrapper exposes no mutable storage, but copy anyway so decode owns
       ;; its finite snapshot independently of the caller's object lifetime.
       (%copy-octet-vector (%octet-storage input)))
      (t
       (let ((copy (make-array length :element-type '(unsigned-byte 8))))
         (loop for index below length
               for octet = (aref input index)
               do (unless (typep octet '(integer 0 255))
                    (%host-failure "UnsupportedHostType"
                                   "decode input contains a non-octet"))
                  (setf (aref copy index) octet))
         copy)))))

(defun decode-exact (input &key (budget (default-resource-budget)))
  (unless (resource-budget-p budget)
    (%host-failure "UnsupportedHostType" "decode budget is not a ResourceBudget"))
  (%with-allocation-refusal (budget)
    (let* ((snapshot (%decode-input-snapshot input budget))
           (state (%new-decoder-state snapshot budget))
           (magic #(76 80 67 68)))
      (loop for expected across magic
            for offset from 0
            do (when (%decoder-at-end-p state)
                 (%fail "InvalidCanonicalGrammar" "TruncatedInput" "magic"
                        :offset offset))
               (unless (= (%decoder-read-octet state "magic") expected)
                 (%fail "InvalidCanonicalGrammar" "InvalidMagic" "magic"
                        :offset offset)))
      (let ((version (%read-uvar state "version-varint"
                                 "NonminimalVersionEncoding")))
        (unless (zerop version)
          (%fail "UnsupportedFormat" "UnsupportedFutureVersion"
                 "version-selection" :offset 4 :detail version)))
      (let ((datum (%parse-value state 1)))
        (unless (%decoder-at-end-p state)
          (%fail "InvalidCanonicalGrammar" "TrailingBytes" "end-of-input"
                 :offset (%decoder-state-position state)))
        datum))))

;;; ---------------------------------------------------------------------------
;;; Shared fixture-AST conversion

(defun %nonnegative-radix-string (integer radix digits)
  (if (zerop integer)
      "0"
      (let ((characters (make-array 16 :element-type 'character
                                    :adjustable t :fill-pointer 0))
            (remaining integer))
        (loop while (plusp remaining)
              do (multiple-value-bind (quotient remainder)
                     (floor remaining radix)
                   (vector-push-extend (char digits remainder) characters)
                   (setf remaining quotient)))
        (let ((result (make-string (length characters))))
          (loop for source downfrom (1- (length characters)) to 0
                for target from 0
                do (setf (char result target) (aref characters source)))
          result))))

(defun %decimal-string (integer)
  (if (minusp integer)
      (concatenate 'string "-"
                   (%nonnegative-radix-string (- integer) 10
                                              "0123456789"))
      (%nonnegative-radix-string integer 10 "0123456789")))

(defun %vector-hex (storage)
  (octets-to-hex (%make-octet-string storage :trusted t)))

(defun %fixture-id-ast (identifier)
  (list
   (cons "t" "id")
   (cons "namespace_utf8_hex"
         (loop for segment across (%identifier-namespace identifier)
               collect (%vector-hex segment)))
   (cons "path_utf8_hex"
         (loop for segment across (%identifier-path identifier)
               collect (%vector-hex segment)))))

(defun datum-to-fixture-ast (datum)
  (%ensure-datum datum)
  (cond
    ((unit-datum-p datum) (list (cons "t" "unit")))
    ((boolean-datum-p datum)
     (list (cons "t" "bool") (cons "v" (%boolean-value datum))))
    ((integer-datum-p datum)
     (list (cons "t" "int")
           (cons "v" (%decimal-string (%integer-value datum)))))
    ((rational-datum-p datum)
     (list (cons "t" "rat")
           (cons "p" (%decimal-string (%rational-numerator datum)))
           (cons "q" (%decimal-string (%rational-denominator datum)))))
    ((string-datum-p datum)
     (list (cons "t" "string")
           (cons "utf8_hex" (%vector-hex (%string-utf8 datum)))))
    ((bytes-datum-p datum)
     (list (cons "t" "bytes")
           (cons "hex" (%vector-hex (%bytes-octets datum)))))
    ((identifier-datum-p datum) (%fixture-id-ast datum))
    ((sequence-datum-p datum)
     (list (cons "t" "seq")
           (cons "items"
                 (loop for item across (%sequence-elements datum)
                       collect (datum-to-fixture-ast item)))))
    ((record-datum-p datum)
     (list
      (cons "t" "record")
      (cons "fields"
            (loop for entry across (%record-entries datum)
                  collect
                  (list (cons "key" (%fixture-id-ast (%entry-key entry)))
                        (cons "value"
                              (datum-to-fixture-ast (%entry-value entry))))))))
    (t (%fail "InternalInvariantFailure" "EncoderInvariantFailure" "internal"))))

(defstruct (%import-state (:constructor %new-import-state (budget)))
  budget
  (active (make-hash-table :test #'eq))
  (nodes 0 :type integer)
  (aggregate-payload 0 :type integer)
  (record-key-work 0 :type integer))

(defun %call-import-active (object state thunk)
  (if (or (consp object) (vectorp object))
      (progn
        (when (gethash object (%import-state-active state))
          (%host-failure "CyclicHostInput"))
        (setf (gethash object (%import-state-active state)) t)
        (unwind-protect (funcall thunk)
          (remhash object (%import-state-active state))))
      (funcall thunk)))

(defun %object-pairs (object)
  ;; Fixture datum/object forms have at most three schema fields.  Apply that
  ;; fixed bound before copying a hostile vector or growing a list snapshot.
  (let ((pairs (%proper-sequence-vector object :limit 3))
        (seen (make-hash-table :test #'equal)))
    (loop for pair across pairs
          do (unless (and (consp pair) (stringp (car pair)))
               (%host-failure "UnsupportedHostType"
                              "fixture object member must be a string-keyed pair"))
             (when (gethash (car pair) seen)
               (%host-failure "UnsupportedHostType" "duplicate fixture object key"))
             (setf (gethash (car pair) seen) t))
    pairs))

(defun %object-value (pairs key &optional missing-value)
  (loop for pair across pairs
        when (string= (car pair) key)
          do (return (cdr pair))
        finally (return missing-value)))

(defparameter +fixture-missing+ (list :fixture-missing))

(defun %require-object-keys (pairs keys)
  (unless (= (length pairs) (length keys))
    (%host-failure "UnsupportedHostType" "fixture object has unexpected fields"))
  (loop for key in keys
        when (eq (%object-value pairs key +fixture-missing+) +fixture-missing+)
          do (%host-failure "UnsupportedHostType"
                            (list "fixture object missing field" key))))

(defun %parse-decimal-host (text budget stage)
  (unless (and (stringp text) (plusp (length text)))
    (%host-failure "UnsupportedHostType" "fixture integer must be decimal text"))
  (unless (resource-budget-p budget)
    (%host-failure "UnsupportedHostType"
                   "fixture decimal parser requires a ResourceBudget"))
  (unless (stringp stage)
    (%host-failure "UnsupportedHostType"
                   "fixture decimal parser requires an explicit stage"))
  (let ((negative nil)
        (index 0))
    (when (char= (char text 0) #\-)
      (setf negative t index 1)
      (when (= index (length text))
        (%host-failure "UnsupportedHostType" "minus without decimal digits")))
    (when (and (> (- (length text) index) 1)
               (char= (char text index) #\0))
      (%host-failure "UnsupportedHostType" "leading zero in fixture integer"))
    (when (and negative
               (= (- (length text) index) 1)
               (char= (char text index) #\0))
      (%host-failure "UnsupportedHostType"
                     "negative zero in fixture integer"))
    (let ((value 0))
      (loop for position from index below (length text)
            for character = (char text position)
            unless (char<= #\0 character #\9)
              do (%host-failure "UnsupportedHostType"
                                "non-decimal fixture integer")
            do (setf value (+ (* value 10)
                              (- (char-code character) (char-code #\0))))
               ;; The temporary magnitude exceeds the configured limit by at
               ;; most one decimal digit; it never grows with the remaining
               ;; hostile input after refusal becomes determinable.
               (%check-integer-budget value budget stage))
      (if negative (- value) value))))

(defun %host-hex-vector (text)
  (octets-copy (hex-to-octets text)))

(defun %host-hex-octet-length (text)
  (unless (and (stringp text) (evenp (length text)))
    (%host-failure "UnsupportedHostType" "fixture hex must have even length"))
  (loop for character across text
        unless (%lower-hex-value character)
          do (%host-failure "UnsupportedHostType"
                            "fixture hex must use lowercase 0-9a-f"))
  (/ (length text) 2))

(defun %import-enter (state depth)
  (let ((budget (%import-state-budget state)))
    (when (> depth (budget-max-depth budget))
      (%resource-failure "ExcessiveNesting" "host-import" budget :detail depth))
    (when (>= (%import-state-nodes state) (budget-max-nodes budget))
      (%resource-failure "NodeBudgetExceeded" "host-import" budget))
    (incf (%import-state-nodes state))))

(defun %import-add-payload (state length single-limit)
  (let ((budget (%import-state-budget state)))
    (when (> length single-limit)
      (%resource-failure "ExcessiveDeclaredLength" "host-import" budget
                         :detail length))
    (when (> (+ (%import-state-aggregate-payload state) length)
             (budget-max-aggregate-payload-octets budget))
      (%resource-failure "AggregatePayloadBudgetExceeded" "host-import" budget))
    (incf (%import-state-aggregate-payload state) length)))

(defun %call-import-sequence (sequence state function
                              &key limit
                                (resource-code "ExcessiveContainerCount"))
  (%call-import-active
   sequence state
   (lambda ()
     (funcall function
              (%proper-sequence-vector
               sequence :limit limit :budget (%import-state-budget state)
               :resource-code resource-code)))))

(defun %import-id-segments
    (source state &optional
                    (segment-limit
                      (budget-max-identifier-segments
                       (%import-state-budget state))))
  (%call-import-sequence
   source state
   (lambda (items)
     (let ((segments (make-array (length items))))
       (loop for index below (length items)
             for hex = (aref items index)
             for octet-count = (%host-hex-octet-length hex)
             do (when (zerop octet-count)
                  (%host-failure "EmptyIdentifierSegment"))
                (%import-add-payload
                 state octet-count
                 (budget-max-segment-octets (%import-state-budget state)))
                (let ((bytes (%host-hex-vector hex)))
                  (%validate-utf8 bytes 0 (length bytes) :mode :host)
                  (setf (aref segments index) bytes)))
       segments))
   :limit segment-limit
   :resource-code "ExcessiveIdentifierSegments"))

(declaim (ftype function %import-ast))

(defun %import-add-record-key-work (key state)
  (let* ((budget (%import-state-budget state))
         (next (+ (%import-state-record-key-work state)
                  (%identifier-value-length key))))
    (when (> next (budget-max-total-record-key-octets budget))
      (%resource-failure "RecordKeyWorkBudgetExceeded" "host-import" budget
                         :detail next))
    (setf (%import-state-record-key-work state) next)))

(defun %import-field (field state depth)
  (%call-import-active
   field state
   (lambda ()
     (let ((pairs (%object-pairs field)))
       (%require-object-keys pairs '("key" "value"))
       (let ((key (%import-ast (%object-value pairs "key") state depth)))
         (unless (identifier-datum-p key)
           (%host-failure "UnsupportedHostType" "fixture record key is not id"))
         ;; Reject an invalid/over-budget key before importing an associated
         ;; value that cannot belong to any successful record.
         (%import-add-record-key-work key state)
         (let ((value (%import-ast (%object-value pairs "value") state depth)))
           (make-record-entry key value)))))))

(defun %import-ast-body (ast state depth)
  (let* ((pairs (%object-pairs ast))
         (tag (%object-value pairs "t" +fixture-missing+))
         (budget (%import-state-budget state)))
    (unless (stringp tag)
      (%host-failure "UnsupportedHostType" "fixture datum has no string tag"))
    (cond
      ((string= tag "unit")
       (%require-object-keys pairs '("t"))
       +unit-datum+)
      ((string= tag "bool")
       (%require-object-keys pairs '("t" "v"))
       (let ((value (%object-value pairs "v")))
         (cond ((or (eq value t) (eq value :json-true)) +true-datum+)
               ((or (null value) (eq value :json-false)) +false-datum+)
               (t (%host-failure "UnsupportedHostType"
                                 "fixture bool payload is not boolean")))))
      ((string= tag "int")
       (%require-object-keys pairs '("t" "v"))
       (let ((integer (%parse-decimal-host (%object-value pairs "v")
                                           budget "host-import")))
         (make-instance '%integer-datum :value integer)))
      ((string= tag "rat")
       (%require-object-keys pairs '("t" "p" "q"))
       (let ((numerator (%parse-decimal-host (%object-value pairs "p")
                                             budget "host-import")))
         (let ((denominator (%parse-decimal-host (%object-value pairs "q")
                                                 budget "host-import")))
           (unless (and (not (zerop numerator)) (> denominator 1)
                        (= 1 (gcd (abs numerator) denominator)))
             (%host-failure
              "UnsupportedHostType"
              "fixture rat must already be a canonical abstract rational"))
           (make-instance '%rational-datum
                          :numerator numerator :denominator denominator))))
      ((string= tag "string")
       (%require-object-keys pairs '("t" "utf8_hex"))
       (let* ((hex (%object-value pairs "utf8_hex"))
              (octet-count (%host-hex-octet-length hex)))
         (%import-add-payload state octet-count
                              (budget-max-single-string-octets budget))
         (let* ((bytes (%host-hex-vector hex))
                (scalars (%validate-utf8 bytes 0 (length bytes) :mode :host)))
           (make-instance '%string-datum :utf8 bytes :scalar-count scalars))))
      ((string= tag "bytes")
       (%require-object-keys pairs '("t" "hex"))
       (let* ((hex (%object-value pairs "hex"))
              (octet-count (%host-hex-octet-length hex)))
         (%import-add-payload state octet-count
                              (budget-max-single-bytes-octets budget))
         (make-instance '%bytes-datum :octets (%host-hex-vector hex))))
      ((string= tag "id")
       (%require-object-keys pairs '("t" "namespace_utf8_hex" "path_utf8_hex"))
       (let* ((namespace
                (%import-id-segments (%object-value pairs "namespace_utf8_hex") state))
              (path
                (%import-id-segments
                 (%object-value pairs "path_utf8_hex") state
                 (- (budget-max-identifier-segments budget)
                    (length namespace))))
              (total (+ (length namespace) (length path))))
         (when (zerop (length path))
           (%host-failure "MissingIdentifierPath"))
         (when (> total (budget-max-identifier-segments budget))
           (%resource-failure "ExcessiveIdentifierSegments" "host-import" budget))
         (make-instance '%identifier-datum :namespace namespace :path path)))
      ((string= tag "seq")
       (%require-object-keys pairs '("t" "items"))
       (%call-import-sequence
        (%object-value pairs "items") state
        (lambda (items)
          (when (> (length items) (budget-max-sequence-items budget))
            (%resource-failure "ExcessiveContainerCount" "host-import" budget))
          (let ((elements (make-array (length items))))
            (loop for index below (length items)
                  do (setf (aref elements index)
                           (%import-ast (aref items index) state (1+ depth))))
            (make-instance '%sequence-datum :elements elements)))
        :limit (budget-max-sequence-items budget)))
      ((string= tag "record")
       (%require-object-keys pairs '("t" "fields"))
       (%call-import-sequence
        (%object-value pairs "fields") state
        (lambda (fields)
          (when (> (length fields) (budget-max-record-fields budget))
            (%resource-failure "ExcessiveContainerCount" "host-import" budget))
          (let ((entries (make-array (length fields))))
            (loop for index below (length fields)
                  do (setf (aref entries index)
                           (%import-field (aref fields index) state (1+ depth))))
            (make-instance '%record-datum
                           :entries (%normalize-record-entries
                                     entries budget "host-import"))))
        :limit (budget-max-record-fields budget)))
      (t (%host-failure "UnsupportedHostType"
                        (list "unknown fixture datum tag" tag))))))

(defun %import-ast (ast state depth)
  (%import-enter state depth)
  (%call-import-active ast state
                       (lambda () (%import-ast-body ast state depth))))

(defun datum-from-fixture-ast (ast &key (budget (default-resource-budget)))
  (unless (resource-budget-p budget)
    (%host-failure "UnsupportedHostType" "fixture budget is not a ResourceBudget"))
  (%with-allocation-refusal (budget)
    (%import-ast ast (%new-import-state budget) 1)))

(defun datum-from-fixture-construction
    (descriptor &key (budget (default-resource-budget)))
  "Invoke the public constructor named by Errata 0.1 fixture metadata.

The descriptor is not a datum AST and never enters the byte decoder."
  (unless (resource-budget-p budget)
    (%host-failure "UnsupportedHostType" "fixture budget is not a ResourceBudget"))
  (%with-allocation-refusal (budget)
    (let* ((pairs (%object-pairs descriptor))
           (operation (%object-value pairs "op" +fixture-missing+)))
      (%require-object-keys pairs '("op" "p" "q"))
      (unless (and (stringp operation) (string= operation "rational"))
        (%host-failure "UnsupportedHostType"
                       "unknown fixture construction operation"))
      (let ((numerator
              (%parse-decimal-host (%object-value pairs "p")
                                   budget "host-import"))
            (denominator
              (%parse-decimal-host (%object-value pairs "q")
                                   budget "host-import")))
        (make-rational-datum numerator denominator :budget budget)))))

;;; ---------------------------------------------------------------------------
;;; Preferred diagnostic rendering (non-identity)

(defun %escaped-diagnostic-string (utf8)
  (let ((string (%decode-utf8-host-string utf8)))
    (with-output-to-string (output)
      (write-char #\" output)
      (loop for character across string
            for code = (char-code character)
            do (cond
                 ((char= character #\") (write-string "\\\"" output))
                 ((char= character #\\) (write-string "\\\\" output))
                 ((= code #x0a) (write-string "\\n" output))
                 ((= code #x0d) (write-string "\\r" output))
                 ((= code #x09) (write-string "\\t" output))
                 ((<= #x20 code #x7e) (write-char character output))
                 (t
                  (write-string "\\u{" output)
                  (write-string (%nonnegative-radix-string
                                 code 16 "0123456789abcdef") output)
                  (write-char #\} output))))
      (write-char #\" output))))

(defun %render-identifier (identifier output)
  (write-string "id(ns=[" output)
  (loop for segment across (%identifier-namespace identifier)
        for first = t then nil
        do (unless first (write-char #\, output))
           (write-string (%escaped-diagnostic-string segment) output))
  (write-string "],path=[" output)
  (loop for segment across (%identifier-path identifier)
        for first = t then nil
        do (unless first (write-char #\, output))
           (write-string (%escaped-diagnostic-string segment) output))
  (write-string "])" output))

(defun %render-datum (datum output)
  (cond
    ((unit-datum-p datum) (write-string "unit" output))
    ((boolean-datum-p datum)
     (write-string (if (%boolean-value datum) "true" "false") output))
    ((integer-datum-p datum)
     (write-string (%decimal-string (%integer-value datum)) output))
    ((rational-datum-p datum)
     (write-string "rat(" output)
     (write-string (%decimal-string (%rational-numerator datum)) output)
     (write-char #\, output)
     (write-string (%decimal-string (%rational-denominator datum)) output)
     (write-char #\) output))
    ((string-datum-p datum)
     (write-string (%escaped-diagnostic-string (%string-utf8 datum)) output))
    ((bytes-datum-p datum)
     (write-string "hex\"" output)
     (write-string (%vector-hex (%bytes-octets datum)) output)
     (write-char #\" output))
    ((identifier-datum-p datum) (%render-identifier datum output))
    ((sequence-datum-p datum)
     (write-char #\[ output)
     (loop for item across (%sequence-elements datum)
           for first = t then nil
           do (unless first (write-char #\, output))
              (%render-datum item output))
     (write-char #\] output))
    ((record-datum-p datum)
     (write-string "record{" output)
     (loop for entry across (%record-entries datum)
           for first = t then nil
           do (unless first (write-char #\, output))
              (%render-identifier (%entry-key entry) output)
              (write-string "=>" output)
              (%render-datum (%entry-value entry) output))
     (write-char #\} output))
    (t (%fail "InternalInvariantFailure" "EncoderInvariantFailure" "internal"))))

(defun render-diagnostic (datum)
  (%ensure-datum datum)
  (with-output-to-string (output)
    (%render-datum datum output)))
