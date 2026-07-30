;;;; adapter0-joint.lisp — §24.3 joint jurisdiction: structural AP0
;;;; validity and Kernel semantic validity as SEPARATE verdicts.
;;;;
;;;; Run:  sbcl --script mneme/adapter0/adapter0-joint.lisp
;;;; from the latent-lisp root.  Exit 0 iff every check passed.
;;;;
;;;; The law: "a structurally valid projection that violates the Kernel
;;;; outcome algebra is rejected by the joint run, not silently
;;;; reclassified as an AP0 parser defect."  This gate demonstrates the
;;;; separation in both jurisdictions:
;;;;  (a) AP0 side — every projection-family vector is judged twice: a
;;;;      STRUCTURAL verdict (bytes decode as one canonical PJ-S/0 datum
;;;;      with the required case fields) and a SEMANTIC verdict (the rule
;;;;      table, whose status legality is Kernel /0's own adopted
;;;;      MANIFESTATION-STATUS-P — reused, never re-derived).  The
;;;;      state-as-status fixture must land structural PASS + semantic
;;;;      FAIL with a Kernel-algebra condition.
;;;;  (b) planted structural defects — malformed bytes and a noncanonical
;;;;      spelling land structural FAIL and are never consulted
;;;;      semantically.
;;;;  (c) journal side — the adopted joint reporting surface
;;;;      (journal0's JOINT-STRUCTURAL-SEMANTIC-REPORT, K0E-26) is
;;;;      exercised on a fixed-nonce scratch store: two verdict slots,
;;;;      each with its own procedure identity.
;;;;
;;;; DETERMINISM: the scratch store uses a FIXED nonce — a declared
;;;; PJ-META-1 deviation exactly as the predecessor lanes declare it
;;;; (test fixture, never a production identity); nothing time- or
;;;; path-dependent is printed.
;;;;
;;;; — CLAVIGER-IV (Claude Fable 5 subagent), 2026-07-30

(load (merge-pathnames "load.lisp"
                       (make-pathname :name nil :type nil
                                      :defaults *load-truename*)))

(in-package #:lisp-plus-adapter0)

(defvar *checks* 0)
(defvar *failures* 0)

(defun check (description thunk)
  (incf *checks*)
  (let ((description (format nil description))
        (outcome (handler-case (if (funcall thunk) :ok :fail)
                   (error (condition) (list :error condition)))))
    (if (eq outcome :ok)
        (format t "[J~3,'0d] ok   ~a~%" *checks* description)
        (progn (incf *failures*)
               (format t "[J~3,'0d] FAIL ~a~@[ (~a)~]~%" *checks* description
                       (when (consp outcome) (second outcome)))))))

(defun note (control &rest arguments)
  (apply #'format t control arguments)
  (terpri))

(note "adapter0-joint — structural AP0 validity and Kernel semantic ~
       validity, two verdicts, never one green counter")

;;; ---------------------------------------------------------------------------
;;; The two-verdict judge over raw fixture octets.

(defun joint-verdicts (octets)
  "Returns (values structural semantic condition):
STRUCTURAL :pass/:fail — canonical PJ-S/0 decode + required case fields;
SEMANTIC   :pass/:fail/:not-consulted — the rule table; never consulted
when the structure already failed."
  (multiple-value-bind (datum status) (decode-pjs0 octets)
    (if (or (not (eq status :canonical))
            (not (record-datum-p datum))
            (not (case-field-present-p datum "family")))
        (values :fail :not-consulted nil)
        (multiple-value-bind (verdict condition) (validate-case datum)
          (values :pass (if (eq verdict :accept) :pass :fail) condition)))))

(note "~%== (a) the eighteen projection-family vectors, two verdicts each ==")

(defvar *structural-passes* 0)
(defvar *semantic-agreements* 0)

(dolist (entry (registry-entries))
  (when (equal "projection" (registry-entry-family entry))
    (let* ((path (merge-pathnames (registry-entry-path entry) +reissue-root+))
           (octets (%strip-trailing-newlines (%read-octets path)))
           (expected (registry-entry-verdict entry)))
      (multiple-value-bind (structural semantic condition) (joint-verdicts octets)
        (check (format nil "~a: structural ~a · semantic ~a~@[ (~a)~] — ~
                            expected semantic ~a"
                       (registry-entry-case-id entry)
                       (string-downcase (symbol-name structural))
                       (string-downcase (symbol-name semantic))
                       condition expected)
          (lambda ()
            (and (eq structural :pass)
                 (incf *structural-passes*)
                 (eq semantic (if (equal expected "accept") :pass :fail))
                 (incf *semantic-agreements*))))))))

(check (format nil "LIVE COUNTERS: ~a structural passes and ~a semantic ~
                    agreements over the projection family — every frozen ~
                    projection vector is STRUCTURALLY canonical; only ~
                    the semantic verdict divides them"
               *structural-passes* *semantic-agreements*)
  (lambda ()
    (let ((projection-count
            (count "projection" (registry-entries)
                   :key #'registry-entry-family :test #'equal)))
      (and (= *structural-passes* projection-count)
           (= *semantic-agreements* projection-count)))))

(check "THE SEPARATION ITSELF: the state-as-status fixture ~
        (BAD-PRJ-STATE-AS-STATUS) is structural PASS + semantic FAIL, ~
        and its condition (projection-output-noncanonical) comes from ~
        Kernel /0's adopted status algebra — a Kernel violation, NOT ~
        reclassified as a parser defect"
  (lambda ()
    (let ((octets (%strip-trailing-newlines
                   (%read-octets
                    (merge-pathnames
                     "vectors/adversarial/BAD-PRJ-STATE-AS-STATUS.pjs"
                     +reissue-root+)))))
      (multiple-value-bind (structural semantic condition)
          (joint-verdicts octets)
        (and (eq structural :pass)
             (eq semantic :fail)
             (equal condition "projection-output-noncanonical")
             ;; The load-bearing predicate is Kernel /0's own:
             (not (lisp-plus-kernel0:manifestation-status-p
                   :absent-after-completion))
             (lisp-plus-kernel0:absence-state-p
              :absent-after-completion))))))

;;; ---------------------------------------------------------------------------
(note "~%== (b) planted structural defects — never consulted semantically ==")

(check "malformed bytes (an unclosed record) land structural FAIL with ~
        semantics :not-consulted"
  (lambda ()
    (multiple-value-bind (structural semantic)
        (joint-verdicts (map '(vector (unsigned-byte 8)) #'char-code
                             "(rec ((id \"ap0\" \"family\")"))
      (and (eq structural :fail) (eq semantic :not-consulted)))))

(check "a PARSEABLE but noncanonical spelling (unsorted record keys) ~
        lands structural FAIL — canonicality is part of structure, and ~
        semantics are still :not-consulted"
  (lambda ()
    (multiple-value-bind (structural semantic)
        (joint-verdicts
         (map '(vector (unsigned-byte 8)) #'char-code
              (concatenate 'string
                           "(rec ((id \"ap0\" \"family\") "
                           "(id \"family\" \"cost\")) "
                           "((id \"ap0\" \"amount\") 1))")))
      ;; Keys spelled \"family\" then \"amount\" violate canonical key
      ;; order: the datum parses, the re-encoding differs, the decode
      ;; status is :noncanonical — a STRUCTURAL refusal.
      (and (eq structural :fail) (eq semantic :not-consulted)))))

(check "a structurally canonical record from a NON-projection family ~
        (BAD-CST-01) still fails SEMANTICALLY with its declared ~
        condition — the structural pass never launders a semantic ~
        violation"
  (lambda ()
    (multiple-value-bind (structural semantic condition)
        (joint-verdicts
         (%strip-trailing-newlines
          (%read-octets (merge-pathnames
                         "vectors/adversarial/BAD-CST-01.pjs"
                         +reissue-root+))))
      (and (eq structural :pass)
           (eq semantic :fail)
           (equal condition "cost-float-noncanonical")))))

;;; ---------------------------------------------------------------------------
(note "~%== (c) the adopted journal-side joint surface (K0E-26) ==")

(defvar *scratch* #p"mneme/adapter0/scratch-joint/")
(when (probe-file *scratch*)
  (sb-ext:delete-directory *scratch* :recursive t))

(check "a fixed-nonce scratch store (declared PJ-META-1 deviation, test ~
        fixture only) yields a joint-structural-semantic-report with TWO ~
        verdict slots, each pass, each under its OWN procedure identity"
  (lambda ()
    (let* ((store (create-journal (merge-pathnames "store/" *scratch*)
                                  :declared-durability "synced"
                                  :nonce-octets
                                  (map '(simple-array (unsigned-byte 8) (*))
                                       #'char-code "adapter0-joint-0")))
           (report (joint-structural-semantic-report store))
           (structural (getf report :structural-verdict))
           (semantic (getf report :semantic-verdict)))
      (and (eq :pass (getf structural :value))
           (eq :pass (getf semantic :value))
           (stringp (getf structural :procedure-id))
           (stringp (getf semantic :procedure-id))
           (not (equal (getf structural :procedure-id)
                       (getf semantic :procedure-id)))))))

(when (probe-file *scratch*)
  (sb-ext:delete-directory *scratch* :recursive t))

;;; ---------------------------------------------------------------------------

(format t "~%adapter0-joint: ~a check~:p, ~a failure~:p~%"
        *checks* *failures*)
(if (zerop *failures*)
    (progn (format t "RESULT: PASS~%") (sb-ext:exit :code 0))
    (progn (format t "RESULT: FAIL~%") (sb-ext:exit :code 1)))
