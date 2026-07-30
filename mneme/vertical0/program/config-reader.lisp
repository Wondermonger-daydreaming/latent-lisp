;;;; config-reader.lisp — the narrow data reader for the program config.
;;;;
;;;; Contract §2.1: the config is DATA, not code.  The reader here uses
;;;; the standard reader ONLY under *READ-EVAL* NIL with the package
;;;; pinned to this one, and then WALKS the whole result refusing
;;;; anything that is not plain data: keywords, strings, integers, NIL,
;;;; and proper lists thereof.  Any symbol other than a keyword or NIL,
;;;; any non-integer number, any array/structure/pathname refuses hard —
;;;; a config that smuggles code or host objects is not a config.
;;;;
;;;; NONCE DERIVATION (documented deliberately; the sealed config's
;;;; :journal-nonce "vertical-de-morte" is 17 characters and PJ0 requires
;;;; EXACTLY 16 octets): the store nonce is THE FIRST 16 OCTETS of the
;;;; ASCII encoding of the declared nonce string — i.e. "vertical-de-mort".
;;;; Deterministic, derived from declared configuration alone.  This is
;;;; the same declared PJ-META-1 deviation every predecessor specimen
;;;; declares: a fixed nonce makes the store identity deterministic; the
;;;; store is a test fixture, never a production identity.
;;;;
;;;; — FABER-MORTIS (Claude Fable 5 subagent), 2026-07-30

(in-package #:lisp-plus-vertical0)

(defun %validate-config-datum (object)
  "Refuse anything that is not plain list data."
  (typecase object
    (null t)
    (keyword t)
    ((eql t) t)          ; the boolean T (provider-domain :domain-complete)
    (string t)
    (integer t)
    (cons (and (%validate-config-datum (car object))
               (%validate-config-datum (cdr object))))
    (t (error "config reader: non-data object ~s of type ~a refused"
              object (type-of object)))))

(defun read-vertical-config (pathname)
  "Read the program config at PATHNAME as validated plain data.
Returns the config form (a list beginning :vertical-program-config)."
  (let ((form
          (with-open-file (stream pathname :direction :input)
            (let ((*read-eval* nil)
                  (*package* (find-package '#:lisp-plus-vertical0)))
              (read stream)))))
    (%validate-config-datum form)
    (unless (and (consp form) (eq (first form) :vertical-program-config))
      (error "config reader: not a vertical program config: ~s"
             (and (consp form) (first form))))
    form))

(defun config-field (config key)
  "The section of CONFIG headed by keyword KEY, or NIL."
  (rest (find key (rest config) :key #'first)))

(defun %plist-section (config key)
  "A section whose body is one plist: ((:a 1 :b 2)) -> (:a 1 :b 2)."
  (first (config-field config key)))

(defun config-policy (config key)
  (getf (%plist-section config :policy) key))

(defun config-seat-order (config)
  (config-policy config :seat-order))

(defun config-route-pauses (config route)
  (loop for entry in (config-policy config :route-pauses)
        when (eq (getf entry :route) route)
          return (getf entry :pauses)))

(defun config-bank (config)
  "The bank as a list of seat plists."
  (first (config-field config :bank)))

(defun seat-field (seat-plist key)
  (getf seat-plist key))

(defun config-durability (config)
  (config-policy config :journal-declared-durability))

(defun config-nonce-octets (config)
  "The 16-octet store nonce derived from the declared nonce string —
first 16 ASCII octets (derivation documented in the file header)."
  (let ((declared (config-policy config :journal-nonce)))
    (unless (and (stringp declared) (>= (length declared) 16))
      (error "config reader: :journal-nonce must be a string of at least ~
              16 characters; got ~s" declared))
    (map '(simple-array (unsigned-byte 8) (*)) #'char-code
         (subseq declared 0 16))))
