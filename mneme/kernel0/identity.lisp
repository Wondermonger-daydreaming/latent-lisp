(in-package #:lisp-plus-kernel0)

(defconstant +identity-procedure+
  "kernel0/explicit-or-content-derived-domain-tagged-string/v0"
  "Kernel /0 identity procedure: callers supply an explicit domain-tagged,
non-empty string, or supply one derived from canonical content by their named
procedure.  Kernel /0 never derives identity from GENSYM, SXHASH, a pointer,
an address, or a pretty-printed label.  The supplied string is snapshotted, so
the resulting identity is restart-stable and not image-local.  Section 4.1
does not impose a store-issued identity mandate.")

(defun %identity-domain-p (domain)
  (member domain
          '(:process
            :logical-operation
            :seat
            :attempt
            :external-request
            :exposure
            :machine-configuration
            :channel-policy
            :capability
            :claim
            :receipt
            :manifestation
            :effect
            :store
            :journal
            :parser
            :procedure
            :principal
            :reconciliation)
          :test #'eq))

(defun %identity-domain-name (domain)
  (string-downcase (symbol-name domain)))

(defun %identity-domain-from-name (name)
  (loop for domain in '(:process
                        :logical-operation
                        :seat
                        :attempt
                        :external-request
                        :exposure
                        :machine-configuration
                        :channel-policy
                        :capability
                        :claim
                        :receipt
                        :manifestation
                        :effect
                        :store
                        :journal
                        :parser
                        :procedure
                        :principal
                        :reconciliation)
        when (string= name (%identity-domain-name domain))
          return domain))

(defstruct (durable-identity
            (:constructor %make-durable-identity (domain name))
            (:copier nil)
            (:conc-name %durable-identity-))
  (domain nil :read-only t)
  (name "" :type string :read-only t))

(defun durable-identity-domain (identity)
  "Return IDENTITY's immutable keyword domain."
  (%durable-identity-domain identity))

(defun durable-identity-name (identity)
  "Return a defensive copy of IDENTITY's name."
  (copy-seq (%durable-identity-name identity)))

(defun %signal-unresolved-identity ()
  (signal-kernel0
   'unresolved-identity
   :failed-invariant
   "§4 and §4.1 [F: ID-1]: every durable identity MUST carry a recognized domain and a non-empty, restart-stable name"))

(defun make-identity (domain name)
  "Construct an immutable durable identity under +IDENTITY-PROCEDURE+.

DOMAIN must be one of the Kernel /0 identity-domain keywords and NAME must be
a non-empty caller-supplied or content-derived string.  The constructor takes
a defensive snapshot.  It never generates, hashes, interns, or derives a name
from host object identity."
  (unless (and (%identity-domain-p domain)
               (stringp name)
               (plusp (length name)))
    (%signal-unresolved-identity))
  (%make-durable-identity domain (copy-seq name)))

(defun identity= (left right)
  "The single named equality for durable identities: EQ domain and STRING= name."
  (and (durable-identity-p left)
       (durable-identity-p right)
       (eq (%durable-identity-domain left)
           (%durable-identity-domain right))
       (string= (%durable-identity-name left)
                (%durable-identity-name right))))

(defun identity-key (identity)
  "Return IDENTITY's canonical diagnostic key in domain:name form."
  (unless (durable-identity-p identity)
    (%signal-unresolved-identity))
  (format nil "~A:~A"
          (%identity-domain-name (%durable-identity-domain identity))
          (%durable-identity-name identity)))

(defun %identity-condition-context (value)
  (when (durable-identity-p value)
    (case (%durable-identity-domain value)
      (:process (list :process-id value))
      (:attempt (list :attempt-id value))
      (:seat (list :seat-id value))
      (:logical-operation (list :operation-id value)))))

(defun require-identity (value expected-domain)
  "Return VALUE only when it is a durable identity in EXPECTED-DOMAIN.
Otherwise refuse the section 4.2 identity-domain substitution."
  (unless (and (durable-identity-p value)
               (%identity-domain-p expected-domain)
               (eq (%durable-identity-domain value) expected-domain))
    (apply #'signal-kernel0
           'identity-drift
           :failed-invariant
           "§4.2 [F: ID-2]: an API accepting one identity domain where another is required MUST perform an explicit receipt-bearing conversion or refuse"
           (%identity-condition-context value)))
  value)

(defun identity->datum (identity)
  "Represent IDENTITY as a CD/0 identifier datum.

The identifier namespace is (\"lisp-plus-kernel0\" \"identity\") and its path
is (domain-name identity-name).  CD/0 snapshots both non-empty UTF-8 segments,
and the fixed namespace makes the representation distinct from unrelated CD/0
identifiers."
  (unless (durable-identity-p identity)
    (%signal-unresolved-identity))
  (lisp-plus-cd0:make-identifier-datum
   '("lisp-plus-kernel0" "identity")
   (list (%identity-domain-name (%durable-identity-domain identity))
         (%durable-identity-name identity))))

(defun datum->identity (datum)
  "Invert the exact Kernel /0 CD/0 identifier representation of an identity."
  (unless (and (lisp-plus-cd0:identifier-datum-p datum)
               (= 2 (lisp-plus-cd0:identifier-datum-namespace-count datum))
               (string=
                "lisp-plus-kernel0"
                (lisp-plus-cd0:identifier-datum-namespace-segment datum 0))
               (string=
                "identity"
                (lisp-plus-cd0:identifier-datum-namespace-segment datum 1))
               (= 2 (lisp-plus-cd0:identifier-datum-path-count datum)))
    (%signal-unresolved-identity))
  (let ((domain
          (%identity-domain-from-name
           (lisp-plus-cd0:identifier-datum-path-segment datum 0)))
        (name (lisp-plus-cd0:identifier-datum-path-segment datum 1)))
    (unless domain
      (%signal-unresolved-identity))
    (make-identity domain name)))
